# VeggieBook
The open source code for the VeggieBook iOS and Android mobile applications.

## iOS Development
### Running the VeggieBook iOS Application from Xcode
#### Open In A Simulator
1. Select a scheme by visiting the main menu and selecting "Product" > "Scheme" > {your scheme}.
2. Select an iOS Simulator destination by visiting the main menu and selecting "Product" > "Destination" > {any iPhone/iPad simulator or iPhone X}. The simulator needed may vary by task.
3. Build and run the selected scheme.
#### Open On A USB Connected Device
1. Log into Apple's [Developer Website](https://developer.apple.com/sign-in-with-apple/)
2. Create a development certificate and download the provisioning profile to launch the VeggieBook application on a device from Xcode, if you don't already have one. The steps below are copied from the prompts for creating a certificate on Apple's website.
    1. To manually generate a Certificate, you need a Certificate Signing Request (CSR) file from your Mac. To create a CSR file, follow the instructions below to create one using Keychain Access.
        1. Create a CSR file. In the Applications folder on your Mac, open the Utilities folder and launch Keychain Access. Within the Keychain Access drop down menu, select Keychain Access > Certificate Assistant > Request a Certificate from a Certificate Authority.
            1. In the Certificate Information window, enter the following information:
                - In the User Email Address field, enter your email address.
                - In the Common Name field, create a name for your private key (e.g., John Doe Dev Key).
                - The CA Email Address field should be left empty.
                -  the "Request is" group, select the "Saved to disk" option.
            2. Click Continue within Keychain Access to complete the CSR generating process.
    2. Upload your personal certificate for development on your [Apple Team Agent account](https://developer.apple.com/account/ios/certificate/create) (assuming you've been added to the development team account as a "Team Agent").
        1. Select "iOS App Development" from the "Development" section and click "Continue".
        2. The instructions for creating a certificate through Keychain Access should be displayed. Select "Continue".
        3. Click "Choose File..." to select the certificate you created through Keychain. Select "Continue".
    3. Add the new certificate to the existing provisioning profile.
        1. Select "Development" under the "Provisioning Profiles" section on the [Certificates, Identifiers & Profiles page](https://developer.apple.com/account/ios/profile/), ensuring "iOS, tvOS, watchOS" is selected in the drop-down at the top, left of the page.
        2. Expand the provisioning profile for the VeggieBook application by clicking the title. Then select "Edit". Permissions are required for this step. Contact someone with adequate permissions if you don't have enough.
        3. Select the newly uploaded certificate from the "Certificates" section and click "Generate". Select "Download" on the following page to download the provisioning profile to your computer.
        4. Double click the downloaded file from the file system. This will automatically open the provisioning file in Xcode.
        5. Verify the setup by visiting the Project Editor page in Xcode. If there are warnings/errors, they will be displayed in the "Signing & Capabilities" tab of the project editor under the "Signing" section for "Debug".
3. Choose a device that will be connected. Your device used must be registered for testing through your development team's Apple developer account. Register the device if it hasn't already been done. If you're unsure if this has been done, proceed with the steps below until an error appears on step 7.iv below.
4. Connect your iOS device to your Mac computer used for development.
5. Select VeggieBook's development scheme by visiting the main menu and selecting "Product" > "Scheme" > {scheme}.
6. Select an iOS Simulator destination by visiting the main menu in Xcode and selecting "Product" > "Destination" > {the connected device} (under the "Device" section).
    1. If you haven't yet set up your device with your Mac, click "No devices connected to 'My Mac'...".
    2. A list of connected devices should show up, select yours, then click "Next".
    3. Unlock your device, tap "Trust" and enter your passcode.
    4. Click "Done".
7. Check that your device is registered under your development team's Apple developer account by visiting the target configuration page and checking the signing details.
    1. In the project navigator pane at the left-hand side of Xcode, select the root-level project, VeggieBook. The project editor should open.
    2. On left-hand side of the project editor, select the VeggieBook option under "Targets".
    3. Select the "Signing and Capabilities" tab on the target editor page.
    4. If there is an issue, under the "Signing" section, a "Status" line item will appear with a red exclamation mark icon that says "No provisioning profile for team '{team}' matching '{provisioning profile}' found". Resolve this issue by registering your device through your development team's Apple developer account.
8. Unlock your iOS device's screen.
9. Build and run the selected scheme. An icon for VeggieBook will appear on your device's home screen. If it isn't visible and the build has completed, place your finger in the middle of the screen and slide it down to reveal the search bar. Enter "VeggieBook" to find it.
See [Apple's guide](https://help.apple.com/xcode/mac/9.0/index.html?localePath=en.lproj#/dev5a825a1ca) for running an app on a connected device for additional help.

### Deployment
Several steps are involved in deploying an application to the App Store. Appropriate distribution certificates and provisioning profiles must be created and the project must be archived and tested. Follow the steps below to make your VeggieBook application available for testing or deploying it to the App Store.

The following steps are a high-level overview of the tasks to complete, specific instructions can be found in the sections below:
1. Obtain or create a distribution certificate and provisioning profile. These are necessary to upload an application to iTunes Connect for testing and deployment. Using an existing distribution certificate is the simplest option if one has already been created by another developer on your team.
2. Add the distribution certificate to your mac keychain.
3. Import the existing provisioning profiles for deployment into Xcode.
4. Archive and upload the VeggieBook application to iTunes Connect and TestFlight. TestFlight provides a place for applications to be tested internally and externally. The VeggieBook application can also be pushed to the App Store after this process via iTunes Connect.
5. Release the VeggieBook application for internal testing with TestFlight.

*Note: TestFlight has known issues with in-app purchases and sometimes presents extra dialogs to users (to log in, for example) when the code does not directly make any calls that would result in such a prompt. These are expected **not** to occur once deployed to production.*
