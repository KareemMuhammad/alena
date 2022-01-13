import 'package:alena/database/blocs/additional_menu_bloc/additional_menu_cubit.dart';
import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:flutter/material.dart';
import '../../utils/shared.dart';

class CheckAdditionalDialog extends StatefulWidget {
  final AdditionalMenuCubit menuCubit;
  final UserCubit userCubit;
  final String category;
  final List<String> categories;

  const CheckAdditionalDialog({Key key, this.menuCubit, this.category, this.userCubit, this.categories}) : super(key: key);
  @override
  _CheckAdditionalDialogState createState() => _CheckAdditionalDialogState();
}

class _CheckAdditionalDialogState extends State<CheckAdditionalDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('القائمة دي موجودة بالفعل!',style: TextStyle(fontSize: 3.5 * SizeConfig.blockSizeVertical,color: button,fontFamily: 'AA-GALAXY')
              ,textAlign: TextAlign.center,),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: RaisedButton(
              color: button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 2,
              onPressed: () async{
                if(widget.categories.isNotEmpty) {
                  await widget.userCubit.removeAllAdditionalOfDeletedMenu(widget.categories);
                }
                await widget.menuCubit.deleteAdditionalSingleMenu(widget.category);
                widget.userCubit.loadUserData();
                Navigator.pop(context,'done');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('تحديث',style: TextStyle(letterSpacing: 1,fontSize: 22,color: white,
                    fontFamily: 'AA-GALAXY'),
                  textAlign: TextAlign.center,),
              ),
            ),
          ),
        ],
      ),
    );
  }

}