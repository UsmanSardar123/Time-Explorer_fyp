import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile
import com.kms.katalon.core.testobject.TestObject
import com.kms.katalon.core.testobject.ConditionType

// =========================================================
// 1. CONFIGURATION: PATH TO YOUR FLUTTER FYP APK FILE
// =========================================================
// Replace this with the exact absolute path to your debug APK on your laptop
String appPath = "C:/Users/Usman/Music/FYP/build/app/outputs/flutter-apk/app-debug.apk"
WebUI.comment("Starting the FYP Application on the Active Emulator...")
// Start the application on your running Android Studio emulator
Mobile.startApplication(appPath, false)

// Give the Flutter engine and Firebase a few seconds to load up initial resources
Mobile.delay(5)

// =========================================================
// 2. DYNAMICALLY DEFINE THE FLUTTER UI OBJECTS
// =========================================================
// This approach creates the objects directly via code, meaning you don't have to map them in the Object Repository folder!

// Define the Email Text Input Field using its Flutter Key identifier
TestObject emailField = new TestObject("input_email")
emailField.addProperty("accessibilityId", ConditionType.EQUALS, "emailField")

// Define the Login Button using its Flutter Key identifier
TestObject loginButton = new TestObject("btn_login")
loginButton.addProperty("accessibilityId", ConditionType.EQUALS, "loginButton")


// =========================================================
// 3. EXECUTE THE AUTOMATED ACTIONS
// =========================================================

// Step A: Tap on the email input field to focus it, then type the email address
Mobile.tap(emailField, 10)
Mobile.setText(emailField, "student@comsats.edu.pk", 10)
WebUI.comment("Email text field successfully populated.")

// Step B: Tap the Login button to execute your Firebase Auth logic
Mobile.tap(loginButton, 10)
WebUI.comment("Login button tapped. Waiting for Firebase database response...")

// Step C: Wait for the authorization network request to finalize and process screen transition
Mobile.delay(5)


// =========================================================
// 4. CLEANUP
// =========================================================
// Close the app session gracefully when testing finishes
Mobile.closeApplication()