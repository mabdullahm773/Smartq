# SMARTQ

## 🔧 Smart Relay Control System

A IoT-based project that controls home relays via a mobile application, RESTful API, and embedded hardware. This system includes:

- 🧠 Embedded control using **ESP32 (ESP-IDF)**
- 📱 Cross-platform mobile app built with **Flutter**
- 🌐 RESTful API in **ASP.NET Core**
- 🗃️ Backend database using **Microsoft SQL Server**
- 🔐 User authentication and profile data managed via **Firebase (Google Auth)**

---

## 🗂️ Key features
| Layer          | Technology             | Purpose                                                  |
| -------------- | ---------------------- | -------------------------------------------------------- |
| Embedded       | ESP32 (ESP-IDF)        | Controls physical relays via GPIO                        |
| Mobile App     | Flutter                | User interface to control and monitor relay states       |
| Backend API    | ASP.NET Core           | RESTful API to manage relays and sync with database      |
| Database       | Microsoft SQL Server   | Stores relay status, user data, and app-related records  |
| Auth + Profile | Firebase (Google Auth) | Handles user login, image, name, and profile information |


## ⚙️ Setup Instructions
### 📟 ESP32 (ESP-IDF)
1. Install ESP-IDF: ESP-IDF Setup Guide
2. Navigate to /esp32_firmware
3. Configure your WiFi credentials and the API URL in hardwarecode 
4. Flash the firmware:
   4.1 idf.py build
   4.2 idf.py -p port(COM3, COM4 etc) flash
   4.3 idf.py monitor (optional)

### 🌐 ASP.NET Core API
1. Install .NET 8,9 SDK
2. Navigate to /restful_api_dotnet
3. Configure appsettings.json with your SQL Server connection string
4. Run and host API on http

### 🗄️ SQL Server
1. Donwload Sql Server
2. Download SSMS
3. Start SSMS and copy and use that connection string in the API code

### 📱 Flutter App Setup (with Firebase)
1. Set up a Firebase project.
3. Connect it with the Flutter project.
2. Enable Google Sign-In under Firebase Auth.
3. Change the API URL in the code to enable the mobile app to fetch the hardware device.

> ⚠️ **Note:**  
> Both the ESP32 device, API and the mobile app **must be connected to the same local network (Wi-Fi)**.  
> This project does **not support public or external network access** for the API or device communication.
