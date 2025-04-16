# 🔋 BatterySDK

**BatterySDK** est un SDK permettant de récupérer facilement le niveau de batterie d'un appareil iOS.  

## 🚀 Installation  

### 📦 Via Swift Package Manager (SPM)  

1. **Ouvrir Xcode** et aller dans :  
   `File > Add Packages...`  
2. **Entrer l'URL du repo GitHub** : https://github.com/Nikaestu/BatterySDK
3. **Sélectionner la version souhaitée** (par défaut, la plus récente).
4. **Cliquer sur "Add Package"**.  

---

## 📖 Utilisation  

### 1️⃣ **Importer le SDK dans votre projet**  
Ajoutez ces ligne à lors de l'initalisation de votre application :  

```swift
import BatterySDK
import OpenTelemetryApi

let configuration = BatteryManager.Configuration(host: "example.com", port: .gRPC)
try BatteryManager.shared.configure(configuration) { OpenTelemetry.instance }
try BatteryManager.shared.startMonitoring()
```

---

## 🔨 Compiler le projet en local
`swift build`

## 🧪 Lancer les tests unitaires
`swift test`
