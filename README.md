# Skills

This flutter app enables the user to search the Lightcast Skills and Job Titles API, select a job title and set of skills, and save these to local storage using the Hive Flutter NoSQL database plugin.

## Getting Started

These instructions assume you have already downloaded Flutter and have iOS and Android simulators on your computer. If not, the initial few videos about setting up Flutter on your computer from this course on YouTube may be of help. [Link](https://www.youtube.com/watch?v=I9ceqw5Ny-4&list=PLSzsOkUDsvdtl3Pw48-R8lcK2oYkk40cm).

You will need to sign up to [Lightcast's Open Skills API](https://lightcast.io/open-skills/access), which is free to access. Once you've done this and confirmed your email address, you will be emailed details of how to connect to the API. This will include a client Id and client secret. Then complete the following:

- Clone this repo to your computer.
- Install dependencies e.g. in the terminal, navigate to the project folder and run 'flutter pub get', or in VS Code open the pubspec.yaml file and click on the download button near the top right of the window to get packages
- Add a .env file inside your lib folder
- Inside your .env file, add these two lines (where you include the relevant info from the lightcast api email you received in the first step mentioned above) 

CLIENT_ID=the-client-id-provided-by-lightcast
CLIENT_SECRET=the-client-secret-provided-by-lightcast

- You should now be able to launch the app in your simulator. 
- On the job title search page, start entering a job title and wait for results to be listed as you type. 
- Tap on a job title you want to select and then click the floating + button to add it your profile
- On the skills search page, do the same - start typing a skill and tap on any of the results that you want to add to your profile. Keep searching and tapping on skills. The ones you have chosen will be highlighted in a list at the bottom of the page.
- When you've added a few skills, tap on the floating + button to add your chosen skills to your profile
- On the My Profile page, you will be able to see the job title and skills you selected on the previous screens.

# To do
- There is still work to be done on navigation as the bottom navigation bar disappears when the user navigates through the app via the floating + buttons.
- Adding ability to delete skills on the My Profile page needs to be added.
