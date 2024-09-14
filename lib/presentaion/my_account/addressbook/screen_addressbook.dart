import 'dart:async';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/my_account/addressbook/screen_New_Address_add.dart';
import 'package:fazzmi/presentaion/checkout/screen_checkout.dart';
import 'package:fazzmi/provider/locationButtonProvider.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/customButton2.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../../model/addressModel/addressModel.dart';
import '../../../provider/addressProvider.dart';
import '../../../provider/shippingAddressConfirmationProvider.dart';
import '../../../widgets/textInput.dart';

class ScreenAddressBook extends StatefulWidget {
  const ScreenAddressBook({Key? key, required this.isBasket, this.item})
      : super(key: key);

  final bool isBasket;
  final AddressData? item;

  @override
  State<ScreenAddressBook> createState() => _ScreenAddressBookState();
}

class _ScreenAddressBookState extends State<ScreenAddressBook> {
  Future<List<AddressData>?>? addressList;
  var box = GetStorage();
  String? _addressId = "103";
  var _index = 0;
  var indexid = 0;
  deleteAddress(addressId) async {
    var response = await Provider.of<AddressProvider>(context, listen: false)
        .deleteAddress(addressId: addressId);
    if (response == "Success") {
      _showSnackbar();

      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         content: const Text('Address removed successfully'),
      //         actions: [
      //           TextButton(
      //               onPressed: () {
      //                 Timer(const Duration(seconds: 1), () {
      //                   Navigator.pop(context);
      //                   loadAddress();
      //                 });
      //               },
      //               child: const Text("OK"))
      //         ],
      //       );
      //     });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("$response"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            );
          });
    }
  }

  getDefaultAddress() {
    final value = context.read<AddressProvider>();
    return _addressId = value.addressList?.first.addressId;
  }

  loadAddress() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresList();
    });
  }

  @override
  void initState() {
    _addressId = getDefaultAddress();
    super.initState();
    loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Address Book",
        icon: Icons.arrow_back_ios,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AddressProvider>(builder: (context, value, child) {
              if (!value.activeStatus) {
                if (value.addressList?.isNotEmpty ?? false) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      _index = index;
                      AddressData item = value.addressList![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
                          child: Column(
                            children: [
                              buildTopButtons(context, index, item),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildRowFormWidget(context, width,
                                            name: "Name",
                                            textWidth: width / 3,
                                            textWidth2: width / 1.8,
                                            value:
                                                '${item.firstname} ${item.lastname}'),
                                        buildRowFormWidget(
                                          context, width,
                                          name: "Address",
                                          textWidth: width / 3,
                                          textWidth2: width / 1.8,
                                          value: "${item.street}\n${item.city}",
                                          // "${item.street},\n${item.city},${item.region}\n"
                                          // "Pin:${item.postcode}"
                                        ),
                                        buildRowFormWidget(
                                          context,
                                          width,
                                          name: "PIN",
                                          textWidth: width / 3,
                                          textWidth2: width / 3,
                                          value: "${item.postcode}",
                                        ),
                                        buildRowFormWidget(
                                          context,
                                          width,
                                          name: "Phone Number",
                                          textWidth: width / 3,
                                          textWidth2: width / 3,
                                          value:
                                              "+${item.phoneCode} - ${item.mobile}",
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, ind) {
                      return const Divider();
                    },
                    itemCount: value.addressList!.length,
                  );
                } else {
                  return const Center(
                    child: TextInput(text1: "NO SAVED ADDRESS"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
          Consumer<AddressProvider>(builder: (context, value, child) {
            if (!value.activeStatus) {
              return Column(
                children: [
                  widget.isBasket
                      ? Row(
                          mainAxisAlignment: !value.activeStatus &&
                                  (value.addressList?.isNotEmpty ?? false)
                              ? MainAxisAlignment.spaceAround
                              : MainAxisAlignment.center,
                          children: [
                              CustomButton2(
                                width: (value.addressList?.isNotEmpty ?? false)
                                    ? MediaQuery.of(context).size.width / 2.2
                                    : MediaQuery.of(context).size.width - 20,
                                buttonName: "ADD ADDRESS",
                                color: primaryColor,
                                buttonAction: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ScreenNewAddress()));
                                },
                                height: 50,
                                textSize: 16,
                              ),
                              Consumer<AddressProvider>(
                                  builder: (context, value, child) {
                                if (!value.activeStatus &&
                                    (value.addressList?.isNotEmpty ?? false)) {
                                  var localvariable;

                                  AddressData items =
                                      value.addressList![indexid];
                                  return CustomButton2(
                                    buttonName: "SELECT ADDRESS",
                                    color: primaryColor,
                                    buttonAction: () {
                                      if (_addressId == "0") {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Oops!!!"),
                                              content: const Text(
                                                  "Please select the Address "),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        // Check for pincode validity
                                        if (items.postcode == "679332" ||
                                            items.postcode == "679331") {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) async {
                                            await Provider.of<
                                                        ShipppingAddressConfirmProvider>(
                                                    context,
                                                    listen: false)
                                                .getCheckoutpage(
                                              addresstype: localvariable = 0,
                                              city: items.city,
                                              countryId: items.countryId,
                                              firstName: items.firstname,
                                              lastName: items.lastname,
                                              postCode: items.postcode,
                                              region: items.region,
                                              regionCode: items.regionId,
                                              regionId: 550,
                                              street: items.street,
                                              telePhone: items.telephone,
                                            );
                                            localvariable = Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ScreenCheckOut()),
                                            );
                                          });
                                        } else {
                                          // Show alert for non-serviceable pincode
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Pincode Not Serviceable"),
                                                content: const Text(
                                                    "Sorry, we don't currently service this pincode."),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("OK"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }
                                    },
                                    height: 50,
                                    textSize: 16,
                                  );
                                } else if (value.addressList?.isNotEmpty ??
                                    false) {
                                  return const SizedBox();
                                } else {
                                  return const SizedBox();
                                }
                              })
                            ])
                      : CustomButton2(
                          buttonName: "ADD ADDRESS",
                          color: primaryColor,
                          buttonAction: () async {
                            Provider.of<LocationButtonProvider>(context,
                                    listen: false)
                                .getCurrentLocation();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScreenNewAddress()));
                          },
                          height: 50,
                          textSize: 16,
                          width: MediaQuery.of(context).size.width - 30,
                        ),
                  height40,
                ],
              );
            } else {
              return const SizedBox();
            }
          })
        ],
      ),
    );
  }

  Column buildRowFormWidget(BuildContext context, double width,
      {textWidth, name, value, textWidth2}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSubFormTextWidget(
                context: context, text: name, width: textWidth),
            buildSubFormTextWidget(
                context: context,
                text: value,
                color: Colors.grey,
                width: textWidth2),
          ],
        ),
        height10
      ],
    );
  }

  SizedBox buildSubFormTextWidget({context, width, text, color}) {
    return SizedBox(
      width: width,
      child: TextInput(
        maxLines: 4,
        text1: text,
        colorOfText: color,
      ),
    );
  }

  buildTopButtons(BuildContext context, int index, AddressData item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<AddressProvider>(builder: (context, valuee, child) {
          return widget.isBasket
              ? Radio(
                  value: item.addressId.toString(),
                  groupValue: _addressId,
                  onChanged: (value) {
                    box.write("actualpinCode", item.postcode);

                    setState(() {
                      _addressId = value.toString();
                      _index = index;
                      indexid = index;
                    });
                  })
              : const SizedBox();
        }),
        buildIconButton(
            buttonName: item.addressType ?? "Home",
            icon: Icons.location_on_outlined),
        // width5,
        Consumer<AddressProvider>(builder: (context, value, child) {
          return CustomButton2(
              borderColor:
                  item.isDefaultBilling == 1 ? primaryColor : Colors.grey,
              buttonAction: () {
                var dataStore = {
                  "customer_id": box.read("customerId"),
                  "firstname": item.firstname,
                  "lastname": item.lastname,
                  "country_id": item.countryId,
                  "city": item.city,
                  "street": item.street,
                  "address_line_1": "",
                  "address_line_2": "",
                  "telephone": item.telephone,
                  "address_type": item.addressType ?? "Home",
                  "region_id": item.regionId,
                  "region": item.region,
                  "phone_code": item.phoneCode ?? "+91",
                  "postcode": item.postcode,
                  "mobile": item.mobile,
                  "area": item.area,
                  "building": item.building,
                  "apartment_number": item.apartmentNumber,
                  "floor": item.floor,
                  "note": item.note,
                  "latitude": item.latitude,
                  "longitude": item.longitude,
                  "is_default_billing": true,
                  "is_default_shipping": true
                };

                box.write("actualpinCode", item.postcode);

                value.addUpdateAddress(
                    addId: item.addressId,
                    data: dataStore,
                    addrPageType: "Modify");
              },
              color: item.isDefaultBilling == 1 ? primaryColor : Colors.grey,
              buttonName:
                  item.isDefaultBilling == 1 ? "Default" : "Set Default",
              textColor: Colors.white,
              textSize: 12,
              height: 33,
              width: 100);
        }),
        buildIconButton(
            buttonName: "Edit",
            icon: Icons.edit,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenNewAddress(
                          addrPageType: "Modify",
                          item: item,
                        )),
              );
            }),
        // const VerticalDivider(
        //   thickness: 1,
        // ),
        widget.isBasket
            ? const SizedBox()
            : buildIconButton(
                buttonName: "Delete",
                icon: Icons.delete_outlined,
                onPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text(
                              'Do you really want to delete this address?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  Timer(const Duration(seconds: 1), () {
                                    deleteAddress(item.addressId);
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text("OK"))
                          ],
                        );
                      });
                },
              ),
      ],
    );
  }

  Row buildIconButton({icon, buttonName, onPress}) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: onPress,
          icon: Icon(
            icon,
            size: 18,
          ),
          label: TextInput(text1: buttonName),
          style: TextButton.styleFrom(
            primary: Colors.black,
          ),
        ),
      ],
    );
  }

  void _showSnackbar() {
    final snack = SnackBar(
      content: Text("Address Removed Successfully"),
      duration: Duration(seconds: 15),
      backgroundColor: Colors.green,
    );
  }
}
