import 'dart:math';
import 'package:alena/database/blocs/additional_menu_bloc/additional_menu_cubit.dart';
import 'package:alena/database/blocs/favorite_bloc/favorite_cubit.dart';
import 'package:alena/database/blocs/order_bloc/order_cubit.dart';
import 'package:alena/database/blocs/product_bloc/product_bloc.dart';
import 'package:alena/database/blocs/vendor_bloc/vendor_bloc.dart';
import 'package:alena/database/repositories/order_repository.dart';
import 'package:alena/database/repositories/product_repository.dart';
import 'package:alena/database/repositories/vendors_repository.dart';
import 'package:alena/services/remote_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:workmanager/workmanager.dart';
import 'models/menu.dart';
import 'models/user.dart';
import 'utils/constants.dart';
import 'package:alena/database/auth_bloc/auth_cubit.dart';
import 'package:alena/database/blocs/menu_bloc/menu_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/database/repositories/menu_repository.dart';
import 'screens/navigation/wrapper_screen.dart';
import 'package:alena/screens/tips/tips_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database/blocs/reg_bloc/reg_cubit.dart';
import 'package:alena/database/repositories/user_repository.dart';
import 'utils/shared.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPreferences sharedPref;
bool prefValue;
List<Menu> _menu;
AppUser _user;
RemoteConfigService remoteConfigService;
PackageInfo packageInfo;
final FirebaseAuth _auth = FirebaseAuth.instance;
final MenuRepository _menuRepo = MenuRepository();
final UserRepository _userRepo = UserRepository();

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   sharedPref = await SharedPreferences.getInstance();
   prefValue = sharedPref.getBool(Utils.SHARED_KEY);
    packageInfo = await PackageInfo.fromPlatform();
  await Firebase.initializeApp();
  await initializeRemoteConfig();

  await Workmanager().initialize(
       callbackDispatcher,
       isInDebugMode: false
   );

   await Workmanager().registerPeriodicTask(
       '1',
       'userMenusTask',
       frequency: Duration(days: 1),
     );

  runApp(MyApp(),);
}

Future initializeRemoteConfig() async {
  remoteConfigService = await RemoteConfigService.getInstance();
  await remoteConfigService.initialize();
}

void callbackDispatcher(){
  Workmanager().executeTask((task, inputData) async{
    await Firebase.initializeApp();
    if(_auth.currentUser != null) {
      _user = await _userRepo.getUserById(_auth.currentUser.uid);
      if(_user.weddingDate.isNotEmpty) {
        print(task);
        final int date = Utils.dateDifference(_user.weddingDate.split(' ')[0], _user.weddingDate.split(' ')[1]);
        if (date > 0) {
          print('$task in');
          _menu = await _menuRepo.getAllMenus(_auth.currentUser.uid);
          List<String> categories = [];
          if (_menu != null || _menu.isNotEmpty) {
            for (Menu mn in _menu) {
              if (mn.list.containsValue(false)) {
                print('contain');
                categories.add(mn.category);
              }
            }
            final String randomCategory = categories[Random().nextInt(categories.length)].toString();
            final String title = ' بنفكرك ان قائمة $randomCategory لسة مخلصتش يا عروسة ';
            print(randomCategory);
            await Utils.showNormalNotification(title);
          }
        }
      }
    }
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(userRepository: UserRepository())..authUser(),
        ),
        BlocProvider(
          create: (context) => UserCubit(userRepository: UserRepository()),
        ),
        BlocProvider(
          create: (context) => FavoriteCubit(userRepository: UserRepository(),productRepository: ProductRepository()),
        ),
        BlocProvider(
          create: (context) => RegCubit(userRepository: UserRepository()),
        ),
        BlocProvider(
          create: (context) => ProductCubit(productRepo: ProductRepository()),
        ),
        BlocProvider(
          create: (context) => OrderCubit(orderRepository: OrderRepository()),
        ),
        BlocProvider(
          create: (context) => VendorCubit(vendorRepo: VendorsRepository(),productRepo: ProductRepository()),
        ),
        BlocProvider(
          create: (context) => MenuCubit(menuRepo: MenuRepository())..loadUserMenu(),
        ),
        BlocProvider(
          create: (context) => AdditionalMenuCubit(menuRepo: MenuRepository())..loadUserAdditionalMenu(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Tajawal-Medium',
          appBarTheme: AppBarTheme(
            color: white,
            iconTheme: IconThemeData(color: white)
          ),
        ),
        home: prefValue != null ? WrapperScreen() : TipsSplashScreen(),
      ),
    );
  }
}
