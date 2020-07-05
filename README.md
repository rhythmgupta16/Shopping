# Shopping

A Shopping App made on Flutter.

## Videos:

* [Authentication](https://www.linkedin.com/posts/rhythm-gupta-848410183_flutter-firebase-startwithgenesis-activity-6681986432359297024-0FtN)

* [Shop Main Screen](https://www.linkedin.com/posts/rhythm-gupta-848410183_graphql-flutter-flutterdev-activity-6685330802911313920-h6dQ)

## Current Files:

### Login.dart

This is the first screen of the app which gives options to Login with email, phone or social logins. It also has option to take user to register with email screen.

### Phone.dart

Here the user can login through OTP authentication.

### Register.dart

This is used to register the user with email.

### ForgotPassword.dart

If the user forgets the password, an email to change the password can be sent from here.

### EditProfile.dart

This screen is used to add the details of the user including a picture.

### GoogleSignIn.dart

This is imported wherever we need Google login.

### ShopMainScreen.dart

Top Four Categories, All Categories, Trending Categories and Featured Categories data is fetched and displayed here.

### Category.dart

Data class for All Categories.

### CategoryItem.dart

Each item's UI fetched from All Categories.

### TopFourCategories.dart

Data class for Top Four Categories.

### TopFourCategoriesItem.dart

Each item's UI fetched from Top Four Categories.

### Trending.dart

Data class for Trending Items.

### TrendingItem.dart

Each item's UI fetched from Trending Items.

### Featured.dart

Data class for Featured Items.

### FeaturedItem.dart

Each item's UI fetched from Featured Items.

### ProductsList.dart

GridView shown after clicking on either TopFourCategories or All Categories.

### ProductsListData.dart

Data class for Products List.

### ProductsListItem.dart

Each item's UI fetched from Products Lists.

### ProductDetails.dart

Details of the product after clicking on any Product.

### ProductDetailsData.dart

Data class for Product Details.

### ProductDetailsItem.dart

Each item's UI fetched from Product Details.

### Search.dart

Screen showing the searched item results.

### SearchArguments.dart

Class to pass searchInput arguments in Navigator.pushNamed() from ShopMainScreen.data to Search.data

### SearchData.dart

Data class for Searched Product.

### SearchItem.dart

Each item's UI fetched from Searched Product.
