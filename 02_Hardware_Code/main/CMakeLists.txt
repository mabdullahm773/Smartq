idf_component_register(SRCS "Smart.c"
                    INCLUDE_DIRS "."
                    REQUIRES driver esp_wifi nvs_flash esp_http_client Api_handle json
                    EMBED_TXTFILES ${project_dir}/server_cert.pem)
