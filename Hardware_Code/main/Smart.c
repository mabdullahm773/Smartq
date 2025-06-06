#include <stdio.h>

#include "esp_wifi.h"
#include "nvs_flash.h"
#include "esp_http_client.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "driver/gpio.h"


#include "Api_handle.h"


// URL AND WIFI MACROS
#define API_URL "http://192.168.1.9:5099/devices"
#define WIFI_SSID "testing"
#define WIFI_PASSWORD "12345678"


static const char *TAG = "HTTP_EVENT_HANDLER"; // Tag for log messages


#define device_1 15
#define device_2 2
#define device_3 4
#define device_4 16

// TASK RUNNING ON CORE 1 TO GET THE API DATA (REALTIME)
void Core1_Task1()
{
    while (1)
    {
        for (int i = 1; i <= 4; i++)
        {
            api_relay_get_value(i);
        }

        vTaskDelay(100 / portTICK_PERIOD_MS);
    }
}

void Core0_Task1()
{
    while (1)
    {
        gpio_set_level(device_1, devices_status.device1 ? 1 : 0);
        gpio_set_level(device_2, devices_status.device2 ? 1 : 0);
        gpio_set_level(device_3, devices_status.device3 ? 1 : 0);
        gpio_set_level(device_4, devices_status.device4 ? 1 : 0);

        vTaskDelay(100 / portTICK_PERIOD_MS);
    
    }
}

void post_data_to_Api()
{
    for (int i = 1; i <= 4 ;i++)
    {
        char buffer[20];
        sprintf(buffer, "device-%d", i);
        api_relay_post_value( i , false , buffer);
    }
}

void gpio_configuration()
{

    gpio_reset_pin(device_1);
    gpio_set_direction(device_1,GPIO_MODE_OUTPUT);
    gpio_set_level(device_1,0);

    gpio_reset_pin(device_2);
    gpio_set_direction(device_2,GPIO_MODE_OUTPUT);
    gpio_set_level(device_2,0);

    gpio_reset_pin(device_3);
    gpio_set_direction(device_3,GPIO_MODE_OUTPUT);
    gpio_set_level(device_3,0);

    gpio_reset_pin(device_4);
    gpio_set_direction(device_4,GPIO_MODE_OUTPUT);
    gpio_set_level(device_4,0);



}
// WIFI INITALIZATION
void wifi_init()
{
    // System initialization
    nvs_flash_init();
    esp_netif_init();
    esp_event_loop_create_default();

    // Initialize Wi-Fi driver
    esp_netif_create_default_wifi_sta();
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    esp_wifi_init(&cfg);

    wifi_config_t wifi_config = {
        .sta = {
            .ssid = WIFI_SSID,
            .password = WIFI_PASSWORD,
        },
    };

    esp_wifi_set_mode(WIFI_MODE_STA);
    esp_wifi_set_config(ESP_IF_WIFI_STA, &wifi_config);
    esp_wifi_start();
    esp_wifi_connect();
}


// MAIN CODE
void app_main(void)
{
    //SETUP 
    wifi_init();
    vTaskDelay(5000 / portTICK_PERIOD_MS);

    post_data_to_Api();
    gpio_configuration();
    
    xTaskCreatePinnedToCore(Core1_Task1, "Core1_Task1", 4096, NULL, 1, NULL, 1);
    xTaskCreatePinnedToCore(Core0_Task1, "Core0_Task1", 4096, NULL, 1, NULL, 0);


    /*
    while (1)
    {
       

        vTaskDelay(200 / portTICK_PERIOD_MS);
    }
    */
    
}
