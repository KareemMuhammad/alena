import 'package:alena/database/blocs/product_bloc/product_bloc.dart';
import 'package:alena/database/blocs/vendor_bloc/vendor_bloc.dart';
import 'package:alena/database/blocs/vendor_bloc/vendor_state.dart';
import 'package:alena/models/product.dart';
import 'package:alena/models/vendors.dart';
import 'package:alena/utils/shared.dart';
import '../../../widgets/sheets/filter_sheet.dart';
import 'package:alena/widgets/helpers/shared_widgets.dart';
import 'package:alena/widgets/product/vendors_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:ui' as ui;

class VendorsScreen extends StatefulWidget {
  final String title;

  const VendorsScreen({Key key, this.title}) : super(key: key);
  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  double max;
  double min;
  List<Vendors> searchedForVendors;
  List<Vendors> allVendors;
  List<Product> productsList;
  bool _isSearching = false;
  final TextEditingController _searchTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<VendorCubit>(context).loadVendorsOfDevice(widget.title);
    BlocProvider.of<VendorCubit>(context).filterVendorsOfDevice(widget.title).then((value) {
      productsList = value;
    });
    BlocProvider.of<ProductCubit>(context).getMaxPriceOfDevice(widget.title).then((value) {
      max = value;
    });
    BlocProvider.of<ProductCubit>(context).getMinPriceOfDevice(widget.title).then((value) {
      min = value;
    });
  }

  Widget _buildSearchField() {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: TextField(
        controller: _searchTextController,
        cursorColor: Colors.grey[700],
        decoration: InputDecoration(
          hintText: 'ابحث عن مرشح معين',
          border: InputBorder.none,
          hintStyle: const TextStyle(color: white, fontSize: 16),
        ),
        style: const TextStyle(color: white, fontSize: 18),
        onChanged: (searchedProduct) {
          addSearchedFOrItemsToSearchedList(searchedProduct);
        },
      ),
    );
  }

  void addSearchedFOrItemsToSearchedList(String searchedProduct) {
    searchedForVendors = allVendors.where((vendor) =>
        vendor.brand.toLowerCase().contains(searchedProduct)).toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear, color: white),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(
            Icons.search,
            color: white,
          ),
        ),
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: button,
        elevation: 2,
        leading: _isSearching
            ? BackButton(color: white,)
            : GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: white,)),
        title: _isSearching ? _buildSearchField() : Text("الترشيحات", style: TextStyle(color: white,fontSize: 20,fontFamily: 'AA-GALAXY'),),
        actions: _buildAppBarActions(),
      ),
      body: BlocBuilder<VendorCubit,VendorState>(
        builder: (BuildContext ctx, VendorState state){
          if(state is VendorsLoaded) {
            allVendors = state.vendors;
            return allVendors.isEmpty ?
            Center(child: Text('مفيش ترشيحات ل${widget.title}  حاليا', style: TextStyle(
                fontSize: 22, color: button, fontFamily: 'AA-GALAXY'), textAlign: TextAlign.center,),)
                : ListView(
                  children: [
                      _filterWidget(
                        _searchTextController.text.isEmpty
                          ? allVendors.length : searchedForVendors.length,
                          context,),
                    GridView.builder(
                      itemCount: _searchTextController.text.isEmpty
                          ? allVendors.length : searchedForVendors.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.8),
                      itemBuilder: (BuildContext context, int index) {
                        return VendorsWidget(vendor: _searchTextController.text.isEmpty
                            ? allVendors[index] : searchedForVendors[index],category: widget.title,);
                      },
                    ),
                  ],
                );
          }else if(state is VendorInitial){
            return GridView.builder(
              itemCount: 6,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.8),
              itemBuilder: (BuildContext context, int index) {
                return loadVendorShimmer();
              },
            );
          }else if(state is VendorLoading){
            return GridView.builder(
              itemCount: 6,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.8),
              itemBuilder: (BuildContext context, int index) {
                return loadVendorShimmer();
              },
            );
          }else if(state is VendorLoadError){
            return Center(child: Text('حدث خطأ فى جلب البيانات! اعد المحاولة', style: TextStyle(
                fontSize: 22, color: black, fontFamily: 'AA-GALAXY'),
              textAlign: TextAlign.center,),);
          }else{
            return Container();
          }
        },
      ),
    );
  }

  Widget _filterWidget(int length,BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              _showMySheet(context);
            },
            child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[800])
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(AntDesign.filter,color: black,size: 20,),
                        const SizedBox(width: 5,),
                        const Text('تصفية',style: TextStyle(fontSize: 19,color: black,),
                          textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
            ),
          ),
          Text('مرشح ($length)', style: TextStyle(
              fontSize: 18, color: Colors.grey[800], fontFamily: 'AA-GALAXY'),
            textAlign: TextAlign.end,),
        ],
      ),
    );
  }

 Widget _headerWidget() {
    return Wrap(alignment: WrapAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 11 * SizeConfig.blockSizeVertical,vertical: 0),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                )
              ]
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                Text('نطاق السعر', style: TextStyle(color: Colors.grey[800], fontSize: 18,fontFamily: 'AA-GALAXY'),),
                const SizedBox(height: 5,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${max == null ? 0 : max.toInt()} LE',
                      style: TextStyle(fontSize: 20,color: Colors.grey[800],fontFamily: 'AA-GALAXY',fontWeight: FontWeight.bold)
                      ,textAlign: TextAlign.center,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
                      child: Icon(Icons.arrow_back,color: Colors.grey[800],size: 20,),
                    ),
                    Text('${min == null ? 0 : min.toInt()} LE',
                      style: TextStyle(fontSize: 20,color: Colors.grey[800],fontFamily: 'AA-GALAXY',fontWeight: FontWeight.bold)
                      ,textAlign: TextAlign.center,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
 }

  void _showMySheet(BuildContext context) {
    showModalBottomSheet(context: context, builder: (_){
      return Wrap(
        children: [
          new FilterSheet(max: max,min: min,prList: productsList,),
        ],
      );
    },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
      ),
    );
  }

}