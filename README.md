# Fishing.ua

Fishing.ua is a Ukrainian fisherman's assistant. Directory and a personal office with records of fishing sessions, catches, locations, equipment, and baits for each registered fisherman.

Built with: Rails 7.1.2, Ruby 3.2.2, postgres, Turbo, Stimulus, Bootstrap, Cloudinary, Trix editor, devise, cancancan.

Test with: RSpec, factory_bot_rails and faker.

This app is written for my dad - the person who supported me in my desire to become a web developer from an electrical engineer. His favorite hobby is fishing. In 2022, a new law was accepted in Ukraine, regulating the rules for amateur fishermen and establishing size and weight restrictions on the catch of various water bioresources.

Although the app is designed to be used only on the territory of Ukraine, because its functionality is made according to our law, all interface text was made with I18n and is easy to change by translating locales.

Each unregistered user can view news, a description of the water bioresources of Ukraine, current restrictions on the size and daily weight of the catch, and penalties for each caught water bioresource that is not suitable for requirements.

After registration, the functionality of the personal account becomes additionally available - Fishing, Catch, Locations, Equipment, and Baits.

Since the size of the allowed catch depends on the region where it is caught, before creating a fishing, you need to add at least one location. Each location has its name, description, and fishing region to which it belongs. When creating fishing, one of the user's locations and its start date are selected. Now you can add a catch.

Catch can be added both from the active fishing page, as well as from the personal page of a water bioresource and the general Catches page. In the last two cases, if there is no active fishing, the app will redirect to the page of fishing creation and issue an informational message.

The main "magic" of the application lies in adding a new catch. If the fisherman does not plan to take the catch, it is enough to select the name of the water bioresource and switch the answer to the question "Where is the catch?" to the "into the water" position. In this case, it is not necessary to enter the length and weight of the caught fish. If the catch is planned to be taken with you, then when adding it, a check is first made to see if this water bioresource can be taken at all. If not, it will not be possible to save it, and a warning about violation of the law will appear on the page. If it is possible to take, then it is checked whether the size of the catch corresponds to the minimum permissible length for the given region. Information about the region is taken from the current fishing location. If the size is too small, it will not be possible to save the catch and a warning will appear with information about the permissible size for the region. If the catch is longer, then the daily weight or number of pieces of the catch is already checked. If the daily norm exists and it is weighted, the "catch weight" field must be filled. If the norms are exceeded, a new warning will appear. If everything is fine, the catch is added and a greeting appears. The created catch cannot be edited, but only viewed and released before the end of fishing. If there is an error in the catch record, it can be deleted and added with the correct data before the end of fishing. When creating a catch, you can also add a photos of it.

After creating a catch, you can add your Equipment and Baits that were used to it. In general, they are not mandatory but they can serve as a hint as to what to use for catch.

There are statistics for Locations, Equipment, Baits, Water Bioresources, and User profile. Which, in the convenient form of tables and pie charts, displays a report on catches, locations, equipment, baits, and water bioresources, respectively. For Fishing, the same information is available on the specific fishing page.

There are three types of users - regular, staff, and admin. All three types of users can also create their Fishing, Catches, Locations, Equipment, and Baits. The administrator can change user roles, except for his own. It is created through db:seed. Each user can edit their email or password or delete their profile completely. The administrator cannot delete his profile.

Only the administrator can add and edit water bioresources, catch size rates, daily norms, and penalties. After all, this is very important information based on law.

News, depending on the date of publication, can be in a draft, published, and scheduled status. The staff can add news and edit or delete the ones created by them and see all drafts and plans. This is the only thing that makes such users different from ordinary ones. Admin has access to manage all news.