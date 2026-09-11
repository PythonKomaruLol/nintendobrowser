#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <switch.h>

int main(int argc, char **argv) {
    // Инициализируем консоль для вывода текста на экран
    consoleInit(NULL);

    // Буфер для сохранения текущего URL
    char current_url[512] = "https://google.com";

    padConfigureInput(1, HidNpadStyleSet_NpadStandard);
    PadState pad;
    padInitializeDefault(&pad);

    while (appletMainLoop()) {
        padUpdate(&pad);
        u64 kDown = padGetButtonsDown(&pad);

        // Нажатие [+] для выхода
        if (kDown & HidNpadButton_Plus) break;

        // Вывод интерфейса на экран консоли перед открытием браузера
        consoleClear();
        printf("==========================================\n");
        printf("       SWITCH HOMEBREW WEB BROWSER        \n");
        printf("==========================================\n\n");
        printf("Current Website: %s\n\n", current_url);
        printf("[A] - Enter URL & Open Browser\n");
        printf("[X] - Quick open Google\n");
        printf("[+] - Exit to Homebrew Menu\n\n");
        printf("Tip: Touch screen and controller cursor\n");
        printf("are fully supported inside the applet!\n");

        // Нажатие [X] — быстро открыть Гугл
        if (kDown & HidNpadButton_X) {
            strcpy(current_url, "https://google.com");
            WebCommonConfig config;
            webPageCreate(&config, current_url);
            webConfigShow(&config, NULL);
        }

        // Нажатие [A] — вызвать клавиатуру и ввести свой адрес
        if (kDown & HidNpadButton_A) {
            SwkbdConfig kbd;
            result_t rc = swkbdCreate(&kbd, 0);
            if (R_SUCCEEDED(rc)) {
                swkbdConfigSetHeaderText(&kbd, "Введите URL сайта:");
                swkbdConfigSetGuideText(&kbd, current_url);
                
                char input_buf[512] = {0};
                rc = swkbdShow(&kbd, input_buf, sizeof(input_buf));
                swkbdClose(&kbd);

                if (R_SUCCEEDED(rc) && strlen(input_buf) > 0) {
                    strncpy(current_url, input_buf, sizeof(current_url) - 1);
                    
                    // Запуск системного Web Applet с введенным URL
                    WebCommonConfig config;
                    webPageCreate(&config, current_url);
                    // Системный веб-апплет сам поддерживает HTML5, тач, 
                    // навигацию и встроенные кнопки назад/вперед от Nintendo!
                    webConfigShow(&config, NULL);
                }
            }
        }

        consoleUpdate(NULL);
    }

    consoleExit(NULL);
    return 0;
}