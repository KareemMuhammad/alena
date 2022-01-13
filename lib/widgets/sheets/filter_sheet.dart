import 'package:alena/database/blocs/vendor_bloc/vendor_bloc.dart';
import 'package:alena/database/blocs/vendor_bloc/vendor_state.dart';
import 'package:alena/models/product.dart';
import 'package:alena/models/vendors.dart';
import 'package:alena/screens/navigation/regions_screen.dart';
import 'package:alena/utils/country_constant.dart';
import 'package:alena/utils/shared.dart';
import 'package:alena/widgets/helpers/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class FilterSheet extends StatefulWidget {
  final double max;
  final double min;
  final List<Product> prList;

  const FilterSheet({Key key, this.max, this.min, this.prList,}) : super(key: key);
  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  int selectedRadio = 0;
  double _startValue;
  double _endValue;
  RangeValues _currentRangeValues;
  dynamic region;
  String _chosenCountry = CountryConstant.ALL_CITIES[0];

  @override
  void initState() {
    super.initState();
    _startValue = widget.min;
    _endValue = widget.max;
    _currentRangeValues =  RangeValues(_startValue, _endValue);
  }

  @override
  Widget build(BuildContext context) {
    final VendorCubit vendorCubit =  BlocProvider.of<VendorCubit>(context);
    return Container(
      height: SizeConfig.screenHeight * 0.7,
      padding:  const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end,
          children: [
                Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical * 25),
                          child: Text('تصفية',style: TextStyle(color: black,fontSize: 18,fontFamily: 'AA-GALAXY'),),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                         Navigator.pop(context);
                       }, icon: const Icon(AntDesign.close),
                        color: Colors.grey[700],
                      )
                    ],
                  ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text('خيارات التصفية',style: TextStyle(color: black,fontSize: 19,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5,top: 10),
              child: Text('السعر',style: TextStyle(color: black,fontSize: 17,fontWeight: FontWeight.bold),),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: RangeSlider(
                values: _currentRangeValues,
                min: widget.min,
                max: widget.max,
                activeColor: button,
                labels: RangeLabels('${_currentRangeValues.start}','${_currentRangeValues.end}'),
                onChanged: (dynamic value) {
                     setState(() {
                       _currentRangeValues = value;
                       _startValue = _currentRangeValues.start;
                       _endValue = _currentRangeValues.end;
                       });
                   },),
            ),
            const SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[800])
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_endValue.toInt()}  EGP',style: TextStyle(color: button,fontSize: 16,fontFamily: 'AA-GALAXY',)
                            ,maxLines: 1,overflow: TextOverflow.ellipsis,),
                          Text('إلى',style: TextStyle(color: Colors.grey[900],fontSize: 15,),),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[800])
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_startValue.toInt()}  EGP',style: TextStyle(color: button,fontSize: 16,fontFamily: 'AA-GALAXY',)
                            ,maxLines: 1,overflow: TextOverflow.ellipsis,),
                          Text('من',style: TextStyle(color: Colors.grey[900],fontSize: 15,),),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 5,top: 8),
              child: Text('المدينة',style: TextStyle(color: black,fontSize: 17,fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 10,),
             Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonFormField(
                  icon: Icon(Icons.add),
                  decoration: textInputDecoration2(''),
                  value: _chosenCountry ?? 'القاهرة',
                  items: CountryConstant.ALL_CITIES.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('$country',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)
                          ,textAlign: TextAlign.end,),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) async{
                    setState(() => _chosenCountry = val );
                    List<Map<String,String>> regionMap = getCategoryOfDevice(val);
                   dynamic result = await navigatorKey.currentState.push(MaterialPageRoute(builder: (_) => RegionsScreen(regions: regionMap,city: _chosenCountry,)));
                   if(result != null){
                     setState(() {
                       region = result;
                     });
                   }
                    },
                ),
              ),
           region != null ?
            Padding(
              padding: const EdgeInsets.only(left: 5,top: 15),
              child: Text('المنطقة',style: TextStyle(color: black,fontSize: 17,fontWeight: FontWeight.bold),),
              ) : const SizedBox(),
            region != null ?
            Padding(
              padding: const EdgeInsets.only(right: 5,top: 8),
              child: Text('$region',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)
                ,textAlign: TextAlign.end,),
            ): const SizedBox(),
            const SizedBox(height: 30,),
                BlocConsumer<VendorCubit,VendorState>(
                    builder: (ctx,state){
                   if(state is VendorLoading){
                     return spinKit;
                   }else{
                     return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         GestureDetector(
                           onTap: (){
                             setState(() {
                               selectedRadio = 0;
                               region = null;
                               _startValue = widget.min;
                               _endValue = widget.max;
                               _currentRangeValues = RangeValues(_startValue, _endValue);
                               _chosenCountry = CountryConstant.ALL_CITIES[0];
                             });
                           },
                           child: Container(
                             width: 120,
                             decoration: BoxDecoration(
                                 color: white,
                                 borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
                                 border: Border.all(color: button)
                             ),
                             child: Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: Center(
                                 child: Text('مسح',style: TextStyle(fontSize: 19,color: button,fontWeight: FontWeight.bold),
                                   textAlign: TextAlign.center,),
                               ),
                             ),
                           ),
                         ),
                         GestureDetector(
                           onTap: (){
                             vendorCubit.emit(VendorLoading());
                             List<Vendors> vrList = vendorCubit.getAllVendors;
                             List<Vendors> filteredList;
                             if(region != null){
                               filteredList = vrList.where((filteredKeywordMap) => widget.prList.any((field) =>
                                   field.vendorId == filteredKeywordMap.id &&
                                   field.price >= _startValue &&
                                   field.price <= _endValue &&
                                   filteredKeywordMap.city == _chosenCountry &&
                                   filteredKeywordMap.regions.contains(region))).toList();
                             }else{
                               filteredList = vrList.where((filteredKeywordMap) => widget.prList.any((field) =>
                                   field.vendorId == filteredKeywordMap.id &&
                                   field.price >= _startValue &&
                                   field.price <= _endValue &&
                                   filteredKeywordMap.city == _chosenCountry)).toList();
                             }
                             vendorCubit.emit(VendorsLoaded(filteredList));
                           },
                           child: Container(
                             width: 130,
                             decoration: BoxDecoration(
                               color: button,
                               borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
                             ),
                             child: Padding(
                               padding: const EdgeInsets.all(10.0),
                               child: const Text('اعرض النتائج',style: TextStyle(fontSize: 19,color: white,fontWeight: FontWeight.bold),
                                 textAlign: TextAlign.center,),
                             ),
                           ),
                         ),
                       ],
                     );
                   }
                }, listener: (ctx,state){
                  if(state is VendorsLoaded){
                    Navigator.pop(context);
                  }
                }),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  List<Map<String,String>> getCategoryOfDevice(String value) {

    if(CountryConstant.ALL_CITIES[0] == value){
     return CountryConstant.CAIRO_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[1] == value){
      return CountryConstant.ALEX_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[2] == value){
      return CountryConstant.DAMIETTA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[3] == value){
      return CountryConstant.ISMAILIA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[4] == value){
      return CountryConstant.SHARKIA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[5] == value){
      return CountryConstant.GIZA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[6] == value){
      return CountryConstant.MENOFIA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[7] == value){
      return CountryConstant.QALYIUBIYA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[8] == value){
      return CountryConstant.SUEZ_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[9] == value){
      return CountryConstant.MATROUH_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[10] == value){
      return CountryConstant.KAFR_SHEIKH_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[11] == value){
      return CountryConstant.QENA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[12] == value){
      return CountryConstant.FAYOUM_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[13] == value){
      return CountryConstant.GHARBIYA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[14] == value){
      return CountryConstant.ASWAN_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[15] == value){
      return CountryConstant.SOHAG_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[16] == value){
      return CountryConstant.DAKAHLIA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[17] == value){
      return CountryConstant.ASSIUT_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[18] == value){
      return CountryConstant.SOUTH_SINAI_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[19] == value){
      return CountryConstant.NORTH_SINAI_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[20] == value){
      return CountryConstant.LUXOR_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[21] == value){
      return CountryConstant.BEHIRA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[22] == value){
      return CountryConstant.RED_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[23] == value){
      return CountryConstant.BENI_SUEF_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[24] == value){
      return CountryConstant.PORT_SAID_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[25] == value){
      return CountryConstant.MINYA_REGIONS;
    }
    else if(CountryConstant.ALL_CITIES[26] == value){
      return CountryConstant.VALLEY_REGIONS;
    }else{
      return [];
    }
  }

}
