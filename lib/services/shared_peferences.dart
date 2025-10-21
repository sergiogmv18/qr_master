import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceC {
 


  /* Verify if have user Logged and will show the logo until that verification is finished
    * @author  SGV - 20250728 
    * @version 1.0 - 20250728 - initial release
    * @return <bool> true - user is logged 
                    false - user no logged 
    */
    Future <bool?> verifyInitialConfirmation() async{
      final sharedPreference = await SharedPreferences.getInstance();
      return sharedPreference.getBool('first_Confirmation');
    }


   /* Create user login
    * @author  SGV - 20250729 
    * @version 1.0 - 20250729 - initial release
    * @return <void>
    */
    Future <void> createUserLogged() async{
      final sharedPreference = await SharedPreferences.getInstance();
      await sharedPreference.setBool('first_Confirmation', true);
    }


   /* delete user login
    * @author  SGV - 20250729 
    * @version 1.0 - 20250729 - initial release
    * @return <void>
    */
    Future<void>deleteAll()async{
      final sharedPreference = await SharedPreferences.getInstance();
      await sharedPreference.clear();
    }
}