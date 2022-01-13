import 'package:alena/database/blocs/user_bloc/user_cubit.dart';
import 'package:alena/models/user.dart';
import 'package:alena/utils/constants.dart';
import '../../../widgets/helpers/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/shared.dart';

class EditInfoScreen extends StatefulWidget {
  final int load;
  final String title;
  final AppUser appUser;

  const EditInfoScreen({Key key, this.load, this.title, this.appUser}) : super(key: key);
  @override
  _EditInfoScreenState createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final TextEditingController aboutController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  String _name;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final UserCubit userCubit = BlocProvider.of<UserCubit>(context);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        title: Text('${widget.title}',style: TextStyle(fontSize: 27,color: white,fontFamily: 'AA-GALAXY')
          ,textAlign: TextAlign.center,),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              _loadScreen(widget.appUser),
             SizedBox(height: 20,),
             isLoading ? spinKit
             : Padding(
                padding: const EdgeInsets.all(10),
                child: RaisedButton(
                  color: button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 2,
                  onPressed: () async{
                    if(formKey.currentState != null) {
                      if (formKey.currentState.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        performUpdate(widget.load, userCubit);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('حفظ',style: TextStyle(letterSpacing: 1,fontSize: 22,color: white,fontFamily: 'AA-GALAXY'),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadScreen(AppUser appUser){
    switch(widget.load){
      case 0 :
        return customEditText(appUser.name);
        break;
      case 1 :
        return customEditText(appUser.email);
        break;
      default : return Container();
    }
  }

  Widget customEditText(String text){
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: button,
          elevation: 2,
          child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {

              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  textDirection: Utils.isRTL(_name.isNotEmpty ? _name : aboutController.text) ? TextDirection.rtl : TextDirection.ltr,
                  onChanged: (value){
                    setState(() {
                      _name = value;
                    });
                  },
                  style: TextStyle(color: black,fontSize: 18,),
                  decoration: textInputDecoration2(text),
                  controller: aboutController,
                  validator: (val) {
                    return val.isEmpty ? 'من فضلك املأ الفراغ' : null;
                  },
                ),
              )
          ),
        ),
      ),
    );
  }

  void performUpdate(int load,UserCubit userCubit){
    switch(load){
      case 0 :
        userCubit.updateName(aboutController.text);
        break;
      case 1 :
        userCubit.updateEmail(aboutController.text);
        break;
      default : return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    aboutController.dispose();
  }

}
