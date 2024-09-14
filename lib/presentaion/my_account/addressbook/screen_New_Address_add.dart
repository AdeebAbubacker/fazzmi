import 'dart:async';
import 'package:fazzmi/provider/addressProvider.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/textInput.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/constants.dart';
import '../../../model/addressModel/addressModel.dart';
import '../../../widgets/custom_button.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

// List<String> addressType = ['Home', 'Office', 'Other'];

String selectedAddress = 'Home';
String addressName = "Home";
List<String> addressNameChoices = ["Home", "Office", "Other"];

class ScreenNewAddress extends StatefulWidget {
  const ScreenNewAddress(
      {Key? key, this.addrPageType = "New", this.item}) // New | Modify | PhEdit
      : super(key: key);
  final AddressData? item;
  final String? addrPageType;

  @override
  State<ScreenNewAddress> createState() => _ScreenNewAddressState();
}

var box = GetStorage();
var logitudebox = box.read("longitude");
var lattitudebox = box.read("lattitude");
var selectedPinCode = box.read("selectedPinCode");
var selectedLocality = box.read("selectedLocality");
var selectedSubLocality = box.read("selectedSubLocality");
// bool isOtpValid = true; // Track OTP validation status
String? otpErrorMessage = ''; // Store error message

class _ScreenNewAddressState extends State<ScreenNewAddress> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  bool isLoading = false;
  bool otpGenerated = false;
  bool otpVerified =
      // (widget.addrPageType == "Modify") ? true :
      false;
  bool showError = false;
  bool readOnly = false;

  // Address? _type = Address.Home;
  String addressTileType = "notMentioned";

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController otpController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController addresstypeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController buildingController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController additionalDirectionsController =
      TextEditingController();
  bool autoDisposeControllers = false;
  bool obserText = true;
  bool _homeFieldVisible = false;
  bool showAddressName = false;
  late String verificationId;
  int? _resendToken;
  int start = 60;
  bool wait = false;
  String currentText = "";

  var onTapRecognizer;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? phoneCode, postCode, city, countryId, region, regionId;
  double? latitude, longitude;

  FocusNode nameFocusNode = FocusNode();
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    if (widget.addrPageType == "New") {
      defaultAddress();
    } else if (widget.addrPageType == "Modify") {
      defaultAddress();
      loadAddress();
      loadUpdateData();
    }
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  defaultAddress() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        // cityController.text = selectedSubLocality ?? "";
        pinCodeController.text = selectedPinCode ?? "";
        // streetController.text = selectedLocality ?? "";

        countryId = '';
        latitude = lattitudebox;
        longitude = logitudebox;
        region = 'kerala';
        regionId = "550";
      });
    });
  }

  loadAddress() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AddressProvider>(context, listen: false)
          .fetchAddresList();
    });
  }

  loadUpdateData() {
    if (widget.item != null) {
      firstNameController.text = widget.item?.firstname ?? "";
      lastNameController.text = widget.item?.lastname ?? "";
      cityController.text = widget.item?.city ?? "";
      mobileNumberController.text = widget.item?.mobile ?? "";
      addressName = widget.item?.addressType; // Value from Address List

      addresstypeController.text =
          (addressName == "Home" || addressName == "Office") ? "" : addressName;

      selectedAddress = (addressName == "Home" || addressName == "Office")
          ? addressName
          : "Other";

      streetController.text = widget.item!.street ?? "";
      areaController.text = widget.item!.street ?? "";

      pinCodeController.text = widget.item?.postcode ?? "";
      buildingController.text = widget.item?.building ?? "";

      additionalDirectionsController.text = widget.item?.note ?? "";
      longitude = double.tryParse(widget.item?.longitude ?? '0.0');
      latitude = double.tryParse(widget.item?.latitude ?? '0.0');
    }
  }

  saveAddressForm() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      var customerId = box.read("customerId");

      var data = {
        "customer_id": customerId, //customerId,
        "firstname": firstNameController.text.toString(),
        "lastname": lastNameController.text.toString(),
        "country_id": 'IN',
        "city": cityController.text.toString(),
        "street": streetController.text.toString(),
        "address_line_1": "",
        "address_line_2": "",
        "telephone": mobileNumberController.text.toString(),
        "address_type": (selectedAddress == "Other")
            ? addresstypeController.text
            : selectedAddress,
        "region_id": 550,
        "region": 'kerala',
        "phone_code": phoneCode ?? "+91",
        "postcode": pinCodeController.text.toString(),
        "mobile": mobileNumberController.text.toString(),
        "area": areaController.text.toString(),
        "building": buildingController.text.toString(),
        "apartment_number": '',
        "floor": '',
        "note": additionalDirectionsController.text.toString(),
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "is_default_billing": false,
        "is_default_shipping": false
      };

      var response = await Provider.of<AddressProvider>(context, listen: false)
          .addUpdateAddress(
              data: data,
              addrPageType: widget.addrPageType,
              addId: (widget.addrPageType == "Modify")
                  ? widget.item?.addressId ?? ""
                  : '');
      // print("yyyy:$response");
      if (response == "Success") {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Address updated successfully!!!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Timer(const Duration(seconds: 1), () {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("OK"))
                ],
              );
            });
        Navigator.pop(context);
        setState(() {
          isLoading = false;
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // print(response);
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
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "", icon: Icons.arrow_back_ios),
        body: ListView(shrinkWrap: true, children: [
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextInput(
                          text1: "Contact Details",
                          size: 20,
                        ),
                        height20,

                        /// FIRST NAME
                        nameWithTestFormField(
                            context: context,
                            widget: TextFormField(
                              // enabled: !otpVerified,
                              // enabled: (widget.addrPageType == "Modify" ||
                              //         otpGenerated)
                              //     ? true
                              //     : false,
                              maxLength: 30,
                              controller: firstNameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: 'Please enter first name',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              focusNode: nameFocusNode,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name required';
                                }
                                return null;
                              },
                            ),
                            textFieldName: "First Name*"),

                        /// LAST NAME
                        nameWithTestFormField(
                            context: context,
                            widget: TextFormField(
                              // enabled: !otpVerified,
                              // enabled: (widget.addrPageType == "Modify" ||
                              //         otpGenerated)
                              //     ? true
                              //     : false,
                              maxLength: 30,
                              controller: lastNameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(
                                hintText: 'Please enter last name',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Last name required';
                                }
                                return null;
                              },
                            ),
                            textFieldName: "Last Name*"),

                        /// PHONE NUMBER
                        const TextInput(text1: "Phone Number*"),

                        Container(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              IntlPhoneField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  enabled: (widget.addrPageType == "Modify" ||
                                          otpGenerated)
                                      ? false
                                      : true,
                                  controller: mobileNumberController,
                                  initialCountryCode: "IN",
                                  onCountryChanged: (Country country) {
                                    setState(() {
                                      phoneCode = country.dialCode;
                                    });
                                  },
                                  showCountryFlag: false,
                                  dropdownIconPosition: IconPosition.trailing,
                                  dropdownIcon: const Icon(
                                      Icons.keyboard_arrow_down_outlined),
                                  decoration: InputDecoration(
                                    hintText: '\tPlease enter phone number',
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    suffixIcon:
                                        (widget.addrPageType == "Modify" ||
                                                otpVerified)
                                            ? const Padding(
                                                padding: EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 8,
                                                    left: 0,
                                                    right: 180),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                ),
                                              )
                                            : null,
                                  )),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: (widget.addrPageType != "Modify" &&
                              !isLoading &&
                              !otpGenerated),
                          child: const Text(
                            "We'll send you a code to verify your number.\nStandard message and data rates apply.",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),

                        height10,

                        Visibility(
                            visible: otpGenerated,
                            child: otpInputWrap()), // Condition Not Changed

                        Visibility(
                          visible: (widget.addrPageType != "Modify" &&
                              !isLoading &&
                              !otpGenerated),
                          child: CustomButton(
                              buttonName: "Generate OTP",
                              width: MediaQuery.of(context).size.width,
                              color: primaryColor,
                              customButton: () async {
                                // log(mobileNumberController.text);

                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  firstNameController.text.toString();
                                  mobileNumberController.text.toString();
                                  lastNameController.text.toString();
                                  mobileNumberController.text.toString();
                                  var response = await _auth.verifyPhoneNumber(
                                    phoneNumber:
                                        "+91${mobileNumberController.text}",
                                    timeout: const Duration(seconds: 60),
                                    verificationCompleted:
                                        (phoneAuthCredential) async {
                                      setState(() {
                                        isLoading = false;
                                        otpGenerated = true;
                                      });
                                      signInWithPhoneAuthCredential(
                                          phoneAuthCredential);
                                    },
                                    verificationFailed:
                                        (verificationFailed) async {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    codeSent:
                                        (verificationId, resendingToken) async {
                                      setState(() {
                                        isLoading = false;
                                        startTimer();
                                        otpGenerated = true;
                                        currentState = MobileVerificationState
                                            .SHOW_OTP_FORM_STATE;
                                        this.verificationId = verificationId;
                                      });
                                    },
                                    codeAutoRetrievalTimeout:
                                        (verificationId) async {},
                                  );
                                }
                              }),
                        ),

                        const VerticalDivider(
                          thickness: 1,
                        ),

                        height20,

                        Visibility(
                          visible:
                              (widget.addrPageType == "Modify" || otpVerified),
                          child: const TextInput(
                            text1: "Delivery Address",
                            size: 20,
                          ),
                        ),

                        height10,

                        //PINCODE

                        SizedBox(
                            height: MediaQuery.of(context).size.height / 40),

                        //HOUSE NAME
                        Visibility(
                          visible:
                              (widget.addrPageType == "Modify" || otpVerified),
                          child: nameWithTestFormField(
                              context: context,
                              widget: TextFormField(
                                controller: streetController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  hintText: 'Enter your full address',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address is required';
                                  }
                                  return null;
                                },
                              ),
                              textFieldName: "Address*"
                              // "House Name, Flat, Company, Apartment*"
                              ),
                        ),

                        SizedBox(
                            height: MediaQuery.of(context).size.height / 40),

                        //AREA
                        Visibility(
                          visible:
                              (widget.addrPageType == "Modify" || otpVerified),
                          child: nameWithTestFormField(
                              context: context,
                              widget: TextFormField(
                                controller: cityController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                  hintText: 'Enter area',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Area is required';
                                  }
                                  return null;
                                },
                              ),
                              textFieldName: "Area and Street*"
                              // "Area, Street, Sector, Village*"
                              ),
                        ),

                        SizedBox(
                            height: MediaQuery.of(context).size.height / 40),
                        Visibility(
                          visible:
                              (widget.addrPageType == "Modify" || otpVerified),
                          child: nameWithTestFormField(
                              context: context,
                              widget: TextFormField(
                                readOnly: true,
                                controller: pinCodeController,
                                decoration: const InputDecoration(
                                  enabled: false,
                                  // enabled: (
                                  //         // widget.addrPageType == "Modify" ||
                                  //         otpVerified)
                                  //     ? false
                                  //     : true,
                                  hintText: 'Please enter pincode',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Pincode is required';
                                  }
                                  return null;
                                },
                              ),
                              textFieldName: "Pincode*"),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 40),

                        // ==========

                        Visibility(
                          visible:
                              (widget.addrPageType == "Modify" || otpVerified),
                          child: nameWithTestFormField(
                            controller: null,
                            context: context,
                            widget: Wrap(
                              direction: Axis
                                  .horizontal, // Make the children wrap horizontally
                              spacing:
                                  8.0, // Optional: Set spacing between items
                              children: List<Widget>.generate(
                                  addressNameChoices.length, (int index) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: addressNameChoices[index],
                                      groupValue: selectedAddress,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedAddress = value!;
                                        });
                                      },
                                    ),
                                    Text(addressNameChoices[index]),
                                  ],
                                );
                              }),
                            ),
                            textFieldName: "Address Type*",
                          ),
                        ),

                        // ==========
//                         addresstypeController.text
// addressName
                        //AREA
                        Visibility(
                          visible: (selectedAddress == "Other" &&
                              (widget.addrPageType == "Modify" || otpVerified)),
                          child: nameWithTestFormField(
                              context: context,
                              widget: TextFormField(
                                controller: addresstypeController,
                                decoration: const InputDecoration(
                                  hintText: 'Please enter an address name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                validator: (value) {
                                  if (selectedAddress == "Other" &&
                                      (value == null || value.isEmpty)) {
                                    return 'Address Name required';
                                  }
                                  return null;
                                },
                              ),
                              textFieldName: ""),
                        ),

                        SizedBox(
                            height: MediaQuery.of(context).size.height / 40),

                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Visibility(
                                visible: (widget.addrPageType == "Modify" ||
                                    otpVerified),
                                child: CustomButton(
                                  buttonName: "Continue",
                                  customButton: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (widget.addrPageType != 'Modify') {
                                      loadUpdateData();
                                    }
                                    saveAddressForm();
                                  },
                                  width: MediaQuery.of(context).size.width,
                                  color: primaryColor,
                                ),
                              ),
                      ]))),
        ]));
  }

//VERIFY OTP
  otpInputWrap() {
    return Visibility(
      visible: otpGenerated && !otpVerified,
      child: Container(
        child: SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Visibility(
                  visible: !otpVerified,
                  child: const TextInput(
                      size: 20, text1: "Enter Your Verification code")),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Visibility(
                  visible: !otpVerified,
                  child: PinCodeTextField(
                    obscureText: false,
                    // animationType: AnimationType.slide,
                    keyboardType: TextInputType.number,
                    controller: otpController,
                    appContext: context,
                    length: 6,
                    validator: (value) {
                      if (value!.isEmpty) {
                        // If OTP field is empty, show an error
                        setState(() {
                          otpController.text.isEmpty;
                          otpErrorMessage = 'Please enter a valid 6-digit OTP';
                        });
                        // } else if (value.length != 6) {
                        //   // If OTP is not 6 digits long, show an error
                        //   setState(() {
                        //     otpController;
                        //     otpErrorMessage = 'OTP must be 6 digits';
                        //   });
                        // }
                        // return null;
                      } else {
                        (value.length != 6);
                        otpErrorMessage = "OTP must be 6 digits";
                      }
                      return null;
                    },
                    onChanged: (String value) async {},
                    onCompleted: (v) {},
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      errorBorderColor: primaryColor,
                      activeColor: const Color.fromARGB(255, 109, 108, 108),
                      activeFillColor: Colors.white,
                      selectedFillColor:
                          const Color.fromARGB(255, 239, 236, 236),
                      selectedColor: const Color.fromARGB(255, 239, 236, 236),
                      inactiveColor: const Color.fromARGB(255, 109, 108, 108),
                      inactiveFillColor:
                          const Color.fromARGB(255, 239, 236, 236),
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    // backgroundColor: Colors.blue.shade50,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                  ),
                ),
              ),
              Visibility(
                visible: !otpVerified,
                child: RichText(
                  text: TextSpan(children: [
                    const TextSpan(
                      text: "Send OTP again in",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextSpan(
                      text: " 00:$start",
                      style: const TextStyle(fontSize: 16, color: primaryColor),
                    ),
                    const TextSpan(
                      text: " Sec ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ]),
                ),
              ),
              Visibility(visible: otpVerified, child: const ScreenNewAddress()),
              Visibility(
                visible: !otpVerified,
                child: CustomButton(
                    buttonName: start == 0 ? "Resend OTP" : "Verify OTP",
                    color: primaryColor,
                    width: MediaQuery.of(context).size.width,
                    customButton: wait
                        ? null
                        : () async {
                            // Check if OTP fields are filled before verification
                            if (otpController.text.isEmpty) {
                              // Show an error message if OTP is not valid
                              setState(() {
                                showError = true;
                              });
                              return;
                            }
                            PhoneAuthCredential phoneAuthCredential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: otpController.text);
                            otpVerified = true;
                            signInWithPhoneAuthCredential(phoneAuthCredential);
                            startTimer();
                            setState(() {
                              showError = otpController.text.isEmpty;
                              wait = true;
                            });
                          }),
              )
            ]),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          wait = false;
          timer.cancel();
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Column nameWithTestFormField(
      {context, textFieldName, labelText, controller, suffixicon, widget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextInput(text1: textFieldName),
        SizedBox(width: MediaQuery.of(context).size.width, child: widget),
      ],
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      isLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        isLoading = false;
      });

      // if (authCredential.user != null) {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => DeliveryAddress()));
      // }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendOTP(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        print('Verification ID: $verificationId');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: _resendToken,
    );
  }
}
