#ifndef API_HANDLE_H
#define API_HANDLE_H

#include <stdio.h>
#include "nvs_flash.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_http_client.h"
#include "esp_log.h"


// Structure definition
typedef struct {
    bool device1;
    bool device2;
    bool device3;
    bool device4;
} Devices_Status;

// Declare the global variable (don't define it here!)
extern Devices_Status devices_status;

esp_err_t _http_event_handler(esp_http_client_event_t *evt);
void api_relay_get_value(int device_id);
void api_relay_post_value(int relay_id, bool relay_status, char *device_name);
void api_relay_put_value(int relay_id, bool relay_status, char *device_name);
void api_device_set_value(int device_id, char *mac_address);
void api_device_get_value(int device_id);

#endif
