import 'dart:ui';
import 'package:alena/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/constants.dart';
import 'package:alena/database/blocs/menu_bloc/menu_cubit.dart';
import 'package:alena/database/blocs/menu_bloc/menu_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/widgets/dialogs/check_existence_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/shared.dart';

class SubCategories extends StatefulWidget {
  final List<String> list;
  final String category;
  final int index;

  const SubCategories({Key key, this.list, this.category, this.index}) : super(key: key);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories>{
  List<int> _selectedIndexes= [];
  List<String> _selectedCategories = [];
  final Map<String, dynamic> values = {};
  String id = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    if(sharedPref.getStringList("${widget.category}" + "Categories" + "$id") != null){
      _selectedCategories.addAll(sharedPref.getStringList("${widget.category}" + "Categories" + "$id"));
      _selectedCategories.forEach((cat) {
        values.putIfAbsent(cat, () => false);
      });
    }
    if(sharedPref.getStringList("${widget.category}" + "Indexes" + "$id") != null){
      List<String> categories = sharedPref.getStringList("${widget.category}" + "Indexes" + "$id");
      List<int> mOriginalList = categories.map((i)=> int.parse(i)).toList();
      _selectedIndexes.addAll(mOriginalList);
    }
  }

  @override
  Widget build(BuildContext context) {
   final MenuCubit menuCubit = BlocProvider.of<MenuCubit>(context);
   final UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(Utils.SUB_CATEGORIES_IMAGES[widget.index],fit: BoxFit.cover,)),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: _blurUpperContainer(),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                color: widget.index == 0 ? white : black,
                iconSize: 30,
                icon: Icon(Icons.arrow_back_ios),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            child: _blurContainer(menuCubit,userCubit),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _bottomContainers(),
          ),
        ],
      ),
    );
  }

  Widget _blurContainer(MenuCubit menuCubit,UserCubit userCubit) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          height: SizeConfig.screenHeight * 0.7,
          width: SizeConfig.screenWidth ,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text('${widget.category}',style: TextStyle(fontFamily: 'AA-GALAXY',fontSize: 3.5 * SizeConfig.blockSizeVertical,color: white,letterSpacing: 1,
                      fontWeight: FontWeight.bold), textAlign: TextAlign.end,),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      children: [
                        ...(_selectedCategories).map((e) {
                          return Center(
                            child: Text('$e',style: TextStyle(fontFamily: 'AA-GALAXY',fontSize: 3 * SizeConfig.blockSizeVertical,
                                color: white,letterSpacing: 1,), textAlign: TextAlign.end,),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  BlocConsumer<MenuCubit,MenuState>(
                    builder: (BuildContext context, MenuState state){
                      return state is MenuLoading ?
                      SpinKitFadingCircle(color: button,size: 45,)
                          : CircleAvatar(
                            radius: 28,
                            backgroundColor: button,
                            child: IconButton(
                                color: white,
                                iconSize: 35,
                                icon: Icon(Icons.add),
                               onPressed: (){
                                if(values.isNotEmpty) {
                                  _saveMyMainList(menuCubit);
                                }else{
                                  Utils.showToast('القائمة فارغة!');
                                }
                        },
                      ),
                          );
                    },
                    listener: (BuildContext context, MenuState state) {
                      if(state is MenuAdded){
                        menuCubit.loadUserMenu();
                        Utils.showToast('تم حفظ القائمة');
                      }else if(state is MenuAddError){
                        Utils.showToast('حدث خطأ فى حفظ القائمة!');
                      }else if(state is MenuExisted){
                        dynamic result = showDialog(context: context, builder: (_){
                          return new BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                backgroundColor: white,
                                child: new CheckMenuDialog(menuCubit: menuCubit,category: widget.category,categories: _selectedCategories,userCubit: userCubit,),
                              )
                          );
                        });
                        if(result != 'done'){
                          menuCubit.loadUserMenu();
                        }
                      }else if(state is MenuDeleted){
                        menuCubit.addMenu(values, widget.category);
                        _savePreferences();
                      }else if(state is MenuDeleteError){
                        Utils.showToast('حدث خطأ فى حذف القائمة!');
                      }else if(state is MenuNotExisted){
                        menuCubit.addMenu(values, widget.category);
                        _savePreferences();
                      }
                    },
                  ),

                ],
              ),
          ),
        ),
      ),
    );
  }

  Widget _blurUpperContainer() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          height: 50,
          width: SizeConfig.screenWidth,
          child: Center(
            child: Text('اختارى قائمتك',style: TextStyle(fontFamily: 'AA-GALAXY',fontSize: 25,
                 color: widget.index == 0 ? white : black,letterSpacing: 1,fontWeight: FontWeight.bold,),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomContainers(){
    return Container(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.list.length,
          itemBuilder: (context,index){
            final _isSelected = _selectedIndexes.contains(index);
            return Container(
              padding: const EdgeInsets.all(8.0),
              width: 160,
              child: RaisedButton(
                color: _isSelected? black : button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 2,
                onPressed: () async{
                  setState((){
                    if(_isSelected){
                      values.remove(widget.list[index]);
                      _selectedIndexes.remove(index);
                      _selectedCategories.remove(widget.list[index]);
                    }else{
                      values[widget.list[index]] = false;
                      _selectedIndexes.add(index);
                      _selectedCategories.add(widget.list[index]);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(widget.list[index],
                    style: TextStyle(letterSpacing: 1,fontSize: 3 * SizeConfig.blockSizeVertical,color: white,fontFamily: 'AA-GALAXY'),
                    textAlign: TextAlign.center,),
                ),
              ),
            );
          }),
    );
  }

  void _saveMyMainList(MenuCubit provider) {
    provider.checkMenuExistence(widget.category);
  }

  void _savePreferences(){
    List<String> stringsIndexesList = _selectedIndexes.map((i)=>i.toString()).toList();
    print(stringsIndexesList.first);
    sharedPref.setStringList("${widget.category}" + "Indexes" + "$id", stringsIndexesList);
    sharedPref.setStringList("${widget.category}" + "Categories" + "$id", _selectedCategories);
  }

}
