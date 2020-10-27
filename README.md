# VeggieBook
The open source code for the VeggieBook iOS and Android mobile applications.

For answers to Frequently Asked Questions about the app, see our [FAQs page](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/FAQs.md).

The iOS version of the app was built by [TechEmpower Inc.](https://www.techempower.com/) while the Android version was built by DiPasquo Consulting.

#### TechEmpower Contact Information:
Email: info@techempower.com
Phone: 310-524-1700

## Video Demo
Watch [this video](https://www.youtube.com/watch?v=BBmlMQ2QuEw) for an explanation and demonstration of the application.

## iOS Development
### Running the VeggieBook iOS Application from Xcode
#### Fill Out Configuration Values in .xcconfig and .plist Files
1. Before attempting to build, there are some `.xcconfig` files in the [VeggieBook](https://github.com/VeggieBookOpenSource/VeggieBook/tree/master/iOS/VeggieBook) folder, fill out the values for those variables.
2. Also before building, in each of the `GoogleService-{schemeName}-Info.plist` [files](https://github.com/VeggieBookOpenSource/VeggieBook/tree/master/iOS/VeggieBook/VeggieBook) you'll need to add the values for `CLIENT_ID`, `REVERSED_CLIENT_ID` and `GOOGLE_APP_ID`.
#### Open In A Simulator
1. Select a scheme by visiting the main menu and selecting "Product" > "Scheme" > {your scheme}.
2. Select an iOS Simulator destination by visiting the main menu and selecting "Product" > "Destination" > {any iPhone/iPad simulator or iPhone X}. The simulator needed may vary by task.
3. Build and run the selected scheme.
#### Open On A USB Connected Device
1. Log into Apple's [Developer Website](https://developer.apple.com/sign-in-with-apple/)
2. Create a development certificate and download the provisioning profile to launch the VeggieBook application on a device from Xcode, if you don't already have one. The steps below are copied from the prompts for creating a certificate on Apple's website.
    1. To manually generate a Certificate, you need a Certificate Signing Request (CSR) file from your Mac. To create a CSR file, follow the instructions below to create one using Keychain Access.
        1. Create a CSR file. In the Applications folder on your Mac, open the Utilities folder and launch Keychain Access. Within the Keychain Access drop down menu, select Keychain Access > Certificate Assistant > Request a Certificate from a Certificate Authority.
        ![Create CSR file](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/createCSR.png)
            1. In the Certificate Information window, enter the following information:
                - In the User Email Address field, enter your email address.
                - In the Common Name field, create a name for your private key (e.g., John Doe Dev Key).
                - The CA Email Address field should be left empty.
                -  the "Request is" group, select the "Saved to disk" option.
            2. Click Continue within Keychain Access to complete the CSR generating process.
    2. Upload your personal certificate for development on your [Apple Developer account](https://developer.apple.com/account/ios/certificate/create) (assuming you've been added to the development team account with high enough permissions - contact your Developer account Admin if your permissions are insufficient).
        1. Click the blue "+" button next to the page title.
        1. Select "iOS App Development" from the "Software" section and click "Continue".
        2. You can find instructions for creating a certificate through Keychain Access by clicking "Learn More".
        3. Click "Choose File..." to select the certificate you created through Keychain. Select "Continue".
    3. Add the new certificate to the existing provisioning profile.
        1. In the "Profiles" section on the [Certificates, Identifiers & Profiles page](https://developer.apple.com/account/ios/profile/), select "Development" and "iOS" from the drop-downs at the top, right of the page.
![Profiles page dropdowns](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/profilesPageDevelopment.png)
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
    4. If there is an issue, under the "Signing" section, a "Status" line item will appear with a red exclamation mark icon that says "No profile for team '{team}' matching '{provisioning profile}' found". Resolve this issue by registering your device through your development team's Apple developer account.
    ![Project editory signing error](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/projectEditorSigningError.png)
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

#### Obtain or Create Distribution Certificate and Provisioning Profile
A distribution certificate is required to deploy an application to TestFlight and the App Store. However, Apple only allows three certificates to be registered at one time. For multiple people to publish the application, a shared certificate is normal. The initial shared certificate should be created on the device that will likely be used the most often for deployment but it may be shared among the team. The certificates expire every 3 years and can be recreated as needed.

##### Create a New Distribution Certificate
In addition to being a member of the appropriate Apple Developer Program, Team Agent or Admin permissions are required to create new distribution certificates.

1. Visit the Apple Developer iOS [Certificate Creation page](https://developer.apple.com/account/resources/certificates/add)
2. From the "Software" category, select "iOS Distribution (App Store and Ad Hoc)".
3. You can find instructions for creating a certificate through Keychain Access by clicking "Learn More".
4. Click "Choose File..." to select the certificate you created through Keychain. Select "Continue".
5. A new provisioning profile may need to be created and associated with the new distribution certificate.
6. From the Certificates, Identifiers and Profiles page, select the Profiles tab on the left.
7. Click the blue "+" button next to the section title.
8. Under the distribution section, select "App Store". Select "Continue".
![Distribution Profile Creation](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/provisioningProfilePageDeploy.png)

##### Use an Existing Distribution Certificate
A developer with the distribution certificate in their local Keychain must export a copy of the certificate and a private key, encrypting it with a password, and safely share it with the developer that will be distributing the application. Below are instructions for each of the developer who has the certificate and the developer who wishes to receive the certificate.

###### Export iOS Distribution Certificate from Keychain
1. Open "Keychain Access" from "Applications" > "Utilities" > "Keychain Access" (or search for it through Spotlight).
2. Select "Certificates" from the "Category" section (in the left column, below the "Keychains" section).
3. Expand the certificate to also display the private key that signed the certificate. The private key will likely be for a specific developer.
4. Highlight the certificate and the private key, right click and select "Export 2 items...", and select a location to save the file. Encrypt the file in a `.p12` with a password. This password will be shared with the developer importing it.
5. Deliver the `.p12` file and associated password to the developer that will be deploying the application.

###### Import iOS Distribution Certificate into Keychain
1. Obtain the `.p12` file and associated password from the team member that exported it for you, placing it somewhere on the system that will be doing the deploys.
2. Double click the `.p12` file. It will be automatically opened in Keychain Access.
3. Enter the password provided into the prompt. This will give you a new private key.
4. Follow the steps in the section below to import the project's provisioning profile into Xcode.

###### Import Existing Provisioning Profiles into Xcode
1. Login to your [Apple Developer Account](https://developer.apple.com/account) and visit the "Certificates, IDs & Profiles" page.
2. Select the "Profiles" section and set the drop-downs at the top right to "Distribution" and "iOS".
![Certificates Deploy Dropdowns](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/certificatesPageDeploy.png)
3. Expand the provisioning profile for the production distribution by clicking the title and selecting "Download".
4. Double click the downloaded file from the file system. This will automatically install it in the Keychain.
5. Verify the setup by visiting the Project Editor page in Xcode. If there are warnings/errors, they will be displayed in the "Signing" section under "Release".
![Project Profile Signing section](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/projectEditorReleaseSigningError.png)

#### Create the App in App Store Connect
1. Log in to [App Store Connect](https://appstoreconnect.apple.com/login).
![App Store Connect Homepage](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/appStoreConnectHomepage.png)
2. Go to "My Apps" > click the blue "+" > "New App".
3. Fill out the form and click "Create".
4. Once your app is created, click on the "VeggieBooks" app and fill out all the information in the "App Store" tab.
![App Information Page](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/appStoreConnectAppInfo.png)

#### Archive and Upload to App Store Connect
1. In the Xcode Project Editor, set the version and build numbers on the project editor’s general target configuration page.
    1. Open the target configuration page.
        1. In the project navigator pane at the left-hand side of Xcode, select the application.
        2. At the top left corner or left hand side of the project editor, select the application option under "Targets".
        3. Select the "General" tab on the target editor page.
    2. Enter the new version and build numbers into the "Version" and "Build" fields under the "Identity" section.
    3. Make sure "iPad" is **unchecked** in the Deployment Info Target Device section. (If you leave it checked, you'll have to add support for iPad and forever maintain support for it)
    ![Build Settings](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/projectEditorNoIpad.png)
    4. Commit the version and tag it for record keeping through git.
2. Archive the application using the Xcode interface.
    1. Select the application as the scheme. "Product" > "Scheme" > {scheme}.
    2. Select "Generic iOS Device" as the target. "Product" > "Destination" > "Generic iOS Device".
    3. Archive the project. From the main menu, select "Product" > "Archive".
3. Upload the archive to App Store Connect.
    1. The Organizer window should open once the project has completed archiving. If it isn't, open it from the main navigation bar by selecting "Window" > "Organizer" > "Archives" tab.
    ![Archive Panel](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/archivePanel.png)
    2. Highlight the recent archive with the version specified previously in the list.
    3. *(Optional)* Click "Validate App". *Note that this is also done when "Distribute App" is selected.*
    4. Click "Distribute App" > "App Store Connect" > "Upload" > Next". *Note that this does not actually upload to the App Store directly. This will push the archive to App Store Connect. Further actions are required in App Store Connect to setup testing and deploy it to the App Store.*
    5. Deselect "Include bitcode for iOS Content" from the distribution options (leaving "Upload your app's symbols to receive symolicated reports from Apple" checked) and click "Next".
    ![Archive Distribution Options](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/archiveDistributionOptions.png)
    6. You might get a dialog mentioning to re-sign. If so, select "Manually manage signing" and select your certificate and profile you created earlier in this process.
    7. The upload will be available in App Store Connect after it processes.
4. TestFlight Internal
    1. Once a build is uploaded, it should be visible on the TestFlight page within [App Store Connect](https://appstoreconnect.apple.com/login). To get there, go to "My Apps" > "VeggieBooks", then click the "TestFlight" tab.
    ![Test Flight Panel](https://github.com/VeggieBookOpenSource/VeggieBook/blob/master/readmeImages/appStoreConnectTestFlight.png)
    2. Add desired internal testers. These will be the people that are notified when a new version of the application is available for testing. You can find the list of available testers on the left under "All Testers".
    3. If you would like to add more testers to the internal App Store Connect developer list:
        1. Go back to the App store Connect homepage.
        2. Select "Users and Access".
        3. Select the blue "+" next to the "Users and Access" title.
        4. Follow the prompts to add a new user.
        5. The added user must accept the invitation to App Store Connect to proceed.
        6. Select "Apps" > "VeggieBooks" > "TestFlight" tab > "App Store Connect Users" tab (left-hand pane).
        7. Select the blue "+" next to the "Testers" title.
        8. Select the user that should be added as a tester for the application and select "Add". If the desired user is not available in the list, ensure they’re added on the iTunes Connect account with proper permissions and that they have accepted the invitation.
    4. Open the application build for internal testing by resolving the missing export compliance warning.
        1. Select "My Apps > the appropriate application > "TestFlight" tab > "iOS" tab (left-hand pane under "Builds").
        2. Expand the drop-down menu for the version that will be tested.
        3. Click the build number link (highlighted in blue) for the build that will be tested.
        4. At the top right corner of the page, click "Provide Export Compliance Information".
        5. For the compliance questions, in the past, VeggieBook answered:
            1.Does your app use encryption? YES
            2. Does your app qualify for any of the exemptions in Category 5, Part 2? YES
        6. Follow the prompts and select "Start Internal Testing".
    5. Testers with the application already installed will receive notice that a new version is available and an update request through push notifications. Everyone added as an internal tester through TestFlight will receive an email regarding the new build.
5. Once you're satisfied with the app, you can submit the app for review by going to the app's "App Store" tab in App Store Connect.
6. There should be a build number on the left side nav, click that.
7. Click "Submit for Review" on the top right.
8. The review process can take a couple days, you should receive an email when the review is complete.
9. If your review is approved, the app will receive a status of "Pending Developer Release", click "Release This Version" on the right side of the pane.
10. Your app will show up in the App Store within a few minutes to an hour.
