#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "nvs_flash.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_http_client.h"
#include "esp_log.h"
#include "Api_handle.h"
#include "cJSON.h"  // Include cJSON

static const char *TAG = "HTTP_EVENT_HANDLER";


Devices_Status devices_status = {
    .device1 = false,
    .device2 = false,
    .device3 = false,
    .device4 = false
};

esp_err_t _http_event_handler(esp_http_client_event_t *evt) {
    switch (evt->event_id) {
        case HTTP_EVENT_ON_DATA: {
            const char *json = (const char *)evt->data;

            cJSON *root = cJSON_Parse(json);
            if (!root || !cJSON_IsArray(root)) {
                ESP_LOGE(TAG, "Invalid JSON data");
                cJSON_Delete(root);
                break;
            }

            int array_size = cJSON_GetArraySize(root);
            for (int i = 0; i < array_size && i < 2; i++) {
                cJSON *item = cJSON_GetArrayItem(root, i);
                cJSON *id = cJSON_GetObjectItem(item, "id");
                cJSON *mac = cJSON_GetObjectItem(item, "mac_Address");

                if (cJSON_IsNumber(id) && cJSON_IsString(mac)) {
                    ESP_LOGI(TAG, "Device ID: %d, MAC Address: %s", id->valueint, mac->valuestring);
                }
            }

            cJSON_Delete(root);
            break;
        }
        default:
            break;
    }
    return ESP_OK;
}

esp_err_t _http_relay_event_handler(esp_http_client_event_t *evt) {
    switch (evt->event_id) {
        case HTTP_EVENT_ON_DATA: {
            const char *json = (const char *)evt->data;

            cJSON *root = cJSON_Parse(json);
            if (!root) {
                ESP_LOGE(TAG, "Failed to parse JSON");
                break;
            }

            cJSON *relay_id = cJSON_GetObjectItem(root, "Id");
            cJSON *device_name = cJSON_GetObjectItem(root, "DeviceName");
            cJSON *relay_status = cJSON_GetObjectItem(root, "RelayStatus");

            if (cJSON_IsNumber(relay_id) && cJSON_IsString(device_name) && cJSON_IsBool(relay_status)) {
                bool status = cJSON_IsTrue(relay_status);
           
                switch (relay_id->valueint) {
                    case 1:
                        devices_status.device1 = status;
                        break;
                    case 2:
                        devices_status.device2 = status;
                        break;
                    case 3:
                        devices_status.device3 = status;
                        break;
                    case 4:
                        devices_status.device4 = status;
                        break;
                    default:
                        ESP_LOGE(TAG, "Invalid Relay ID: %d", relay_id->valueint);
                        break;
                }
               

            } else if (cJSON_IsString(relay_status)) {
                bool status = (strcmp(relay_status->valuestring, "true") == 0);

                switch (relay_id->valueint) {
                    case 1:
                        devices_status.device1 = status;
                        break;
                    case 2:
                        devices_status.device2 = status;
                        break;
                    case 3:
                        devices_status.device3 = status;
                        break;
                    case 4:
                        devices_status.device4 = status;
                        break;
                    default:
                        ESP_LOGE(TAG, "Invalid Relay ID: %d", relay_id->valueint);
                        break;
                }
            
            } else {
                ESP_LOGE(TAG, "JSON fields are not valid types");
            }

            cJSON_Delete(root);
            break;
        }
        default:
            break;
    }
    return ESP_OK;
}


void api_relay_get_value(int device_id )
{
    char url[100];
    sprintf(url, "http://192.168.43.30:5099/relay/%d", device_id);  // Use device_id instead of undefined variable

    esp_http_client_config_t config = {
        .url = url,
        .event_handler = _http_relay_event_handler,
        .transport_type = HTTP_TRANSPORT_OVER_SSL,
        .cert_pem = NULL, 
        .skip_cert_common_name_check = true,
    };
    
    esp_http_client_handle_t client = esp_http_client_init(&config);
    esp_http_client_perform(client);
    esp_http_client_cleanup(client);

}

void api_relay_put_value( int relay_id , bool relay_status , char *device_name )
{

    char url[100];
    char payload[100];

    // Example payload for setting a relay value
    sprintf(payload, "{\"Id\": %d, \"DeviceName\": \"%s\", \"RelayStatus\": %s}", relay_id, device_name , relay_status ? "true" : "false");
    // 1 for ON or 0 for OFF
    sprintf(url, "http://192.168.43.30:5099/relay/%d", relay_id);

    esp_http_client_config_t config = {
        .url = url,
        .event_handler = NULL, // No event handler for set value
        .transport_type = HTTP_TRANSPORT_OVER_TCP,
        .cert_pem = NULL, 
        .skip_cert_common_name_check = true,
    };
    
    esp_http_client_handle_t client = esp_http_client_init(&config);

    // ❗ Add correct headers like in curl
    esp_http_client_set_method(client, HTTP_METHOD_PUT);
    esp_http_client_set_header(client, "Content-Type", "application/json");
    esp_http_client_set_header(client, "accept", "text/plain");
    esp_http_client_set_post_field(client, payload, strlen(payload));

    esp_http_client_perform(client);
    esp_http_client_cleanup(client);

}

void api_relay_post_value(int relay_id, bool relay_status, char *device_name)
{
    char url[100];
    char payload[100];

    // Prepare JSON payload
    sprintf(payload, "{\"Id\": %d, \"DeviceName\": \"%s\", \"RelayStatus\": %s}", 
            relay_id, device_name, relay_status ? "true" : "false");

    // URL for POST - typically without ID in RESTful APIs
    sprintf(url, "http://192.168.43.30:5099/relay");

    esp_http_client_config_t config = {
        .url = url,
        .event_handler = NULL,
        .transport_type = HTTP_TRANSPORT_OVER_TCP,
        .cert_pem = NULL,
        .skip_cert_common_name_check = true,
    };

    esp_http_client_handle_t client = esp_http_client_init(&config);

    esp_http_client_set_method(client, HTTP_METHOD_POST);
    esp_http_client_set_header(client, "Content-Type", "application/json");
    esp_http_client_set_header(client, "accept", "text/plain");
    esp_http_client_set_post_field(client, payload, strlen(payload));

    esp_err_t err = esp_http_client_perform(client);
    if (err == ESP_OK) {
        ESP_LOGI("API_POST", "POST successful, Status = %d", esp_http_client_get_status_code(client));
    } else {
        ESP_LOGE("API_POST", "POST failed: %s", esp_err_to_name(err));
    }

    esp_http_client_cleanup(client);
}


void api_device_set_value(int device_id, char *mac_address)
{
    char url[100];
    char payload[200];  // Make sure size is enough

    // ✅ Your payload format matches the curl request
    sprintf(payload, "{\"id\": %d, \"mac_Address\": \"%s\"}", device_id, mac_address);

    // ✅ POSTing to /devices, just like in the curl
    sprintf(url, "http://192.168.43.30:5099/devices");

    esp_http_client_config_t config = {
        .url = url,
        .event_handler = NULL,
        .transport_type = HTTP_TRANSPORT_OVER_TCP, // ❗ Change to TCP for plain HTTP
        .cert_pem = NULL,
    };

    esp_http_client_handle_t client = esp_http_client_init(&config);

    // ❗ Add correct headers like in curl
    esp_http_client_set_method(client, HTTP_METHOD_POST);
    esp_http_client_set_header(client, "Content-Type", "application/json");
    esp_http_client_set_header(client, "accept", "text/plain");
    esp_http_client_set_post_field(client, payload, strlen(payload));

    esp_http_client_perform(client);
    esp_http_client_cleanup(client);
}



void api_device_get_value( int device_id)
{   
    char url[100];
    sprintf(url, "http://192.168.43.30:5099/devices/%d", device_id);

    esp_http_client_config_t config = {
        .url = url,
        .event_handler = _http_event_handler,
        .transport_type = HTTP_TRANSPORT_OVER_SSL,
        .cert_pem = NULL, 
        .skip_cert_common_name_check = true,
    };
    
    esp_http_client_handle_t client = esp_http_client_init(&config);
    esp_http_client_perform(client);
    esp_http_client_cleanup(client);
}
