# 🔋 BatterySDK

**BatterySDK** est un SDK permettant de récupérer facilement le niveau de batterie d'un appareil iOS.  

## 🚀 Installation  

### 📦 Via Swift Package Manager (SPM)  

1. **Ouvrir Xcode** et aller dans :  
   `File > Add Packages...`  
2. **Entrer l'URL du repo GitHub** : 
3. **Sélectionner la version souhaitée** (par défaut, la plus récente).
4. **Cliquer sur "Add Package"**.  

---

## 📖 Utilisation  

### 1️⃣ **Importer le SDK dans votre projet**  
Ajoutez cette ligne dans vos fichiers Swift :  

"import BatterySDK

let batteryLevel = BatteryManager.shared.getBatteryLevel()
print("🔋 Niveau de batterie : \(batteryLevel * 100)%")"

---

## 🔨 Compiler le projet en local
`swift build`

## 🧪 Lancer les tests unitaires
`swift test`
