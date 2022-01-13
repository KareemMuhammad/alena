import 'dart:ui';
import 'package:alena/database/blocs/additional_menu_bloc/additional_menu_cubit.dart';
import 'package:alena/database/blocs/additional_menu_bloc/additional_menu_state.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/utils/constants.dart';
import 'package:alena/utils/shared.dart';
import 'package:alena/widgets/dialogs/check_additional_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewCategoryScreen extends StatefulWidget {

  @override
  _NewCategoryScreenState createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController itemsController = TextEditingController();
  List<dynamic> currentContacts = [];
  final Map<String, dynamic> values = {};
  String _name = '';

  @override
  Widget build(BuildContext context) {
    final AdditionalMenuCubit menuCubit = BlocProvider.of<AdditionalMenuCubit>(context);
    final UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('اضافة قسم جديد',style: TextStyle(fontSize: 22,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                    textDirection: Utils.isRTL(_name.isNotEmpty ? _name : titleController.text) ? TextDirection.rtl : TextDirection.ltr,
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'اسم القسم',
                      hintTextDirection: TextDirection.rtl,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: button, width: 2.0),
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    onChanged: (val){
                      setState(() {
                        _name = val;
                      });
                    },
                    validator: (value) {
                      return value.isEmpty ? 'لازم تضيفى اسم للقسم' : null;
                    }
                ),
              ),
              contactsWidget(),
              BlocConsumer<AdditionalMenuCubit,AdditionalMenuState>(
                builder: (BuildContext context, AdditionalMenuState state){
                  return state is MenuLoading ?
                  SpinKitFadingCircle(color: button,size: 45,)
                      : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            color: button,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 4,
                            onPressed: () {
                              if(_formKey.currentState.validate() && currentContacts.isNotEmpty){
                                for(String item in currentContacts){
                                  values[item] = false;
                                }
                                _saveMyMainList(menuCubit);
                              }
                           },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('اضافة',style: TextStyle(fontSize: 23,color: white,fontFamily: 'AA-GALAXY'),
                                textAlign: TextAlign.center,),
                            ),
                    ),
                  );
                },
                listener: (BuildContext context, AdditionalMenuState state) {
                  if(state is MenuAdded){
                    menuCubit.loadUserAdditionalMenu();
                    Utils.showToast('تم حفظ القائمة');
                    setState(() {
                      currentContacts.clear();
                      titleController.clear();
                      itemsController.clear();
                    });
                  }else if(state is MenuAddError){
                    Utils.showToast('حدث خطأ فى حفظ القائمة!');
                  }else if(state is MenuExisted){
                    dynamic result = showDialog(context: context, builder: (_){
                      return new BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Dialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            backgroundColor: white,
                            child: new CheckAdditionalDialog(menuCubit: menuCubit,category: titleController.text,categories: [],userCubit: userCubit,),
                          )
                      );
                    });
                    if(result != 'done'){
                      menuCubit.loadUserAdditionalMenu();
                    }
                  }else if(state is MenuDeleted){
                    menuCubit.addAdditionalMenu(values, titleController.text);
                  }else if(state is MenuDeleteError){
                    Utils.showToast('حدث خطأ فى حذف القائمة!');
                  }else if(state is MenuNotExisted){
                    menuCubit.addAdditionalMenu(values, titleController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactsWidget(){
    return Column(
      children: [
        currentContacts == null || currentContacts.isEmpty ? const SizedBox()
            :  Column(
          children: [
          ...(currentContacts).map((contact) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        setState(() {
                          currentContacts.remove(contact);
                        });
                      },
                      color: button,
                    ),
                    Text('$contact',style: TextStyle(fontSize: 20,color: black,fontFamily: 'AA-GALAXY')
                      ,textAlign: TextAlign.center,),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
              controller: itemsController,
              decoration: InputDecoration(
                hintText: 'اسم العنصر',
                hintTextDirection: TextDirection.rtl,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: button, width: 2.0),
                    borderRadius: BorderRadius.circular(20)
                ),
              ),
              validator: (value) {
                return value.isEmpty ? 'لازم تضيفى اسم العنصر' : null;
              }
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle),
          onPressed: (){
            if(_formKey.currentState.validate()) {
              if(!currentContacts.contains(itemsController.text))
              setState(() {
                currentContacts.add(itemsController.text);
              });
            }
          },
          color: button,
          iconSize: 30,
        ),
      ],
    );
  }

  void _saveMyMainList(AdditionalMenuCubit provider) {
    provider.checkAdditionalMenuExistence(titleController.text);
  }
}
