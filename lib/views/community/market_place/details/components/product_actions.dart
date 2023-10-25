import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:residents/components/text.dart';
import 'package:residents/controllers/community/chat_controller.dart';
import 'package:residents/controllers/community/market_controller.dart';
import 'package:residents/helpers/constants.dart';
import 'package:residents/models/community/product.dart';
import 'package:residents/utils/app_theme.dart';
import 'package:residents/views/community/chat/messages.dart';

class ProductActions extends StatefulWidget {
  ProductActions({required this.product});

  final Product product;

  @override
  State<ProductActions> createState() => _ProductActionsState();
}

class _ProductActionsState extends State<ProductActions> {
  final ChatController _chatController = Get.find();

  final CommerceController _commerceController = Get.find();

  bool isProductSeller() => widget.product.seller.email == _chatController.resident.value.email;

  late bool _isAvailable = false;
  late String _residentId;

  @override
  void initState() {
    _isAvailable = widget.product.outOfStock;
    _residentId = _chatController.resident.value.id!;
    super.initState();
  }

  void _gotoConversationScreen() async {
    String? conversationId = await _chatController.getConversationIdFor(
      authUserId: _residentId,
      remoteUserId: widget.product.sellerId,
    );
    conversationId ??= "${_residentId}_${widget.product.sellerId}";
    widget.product.seller.updateUid = widget.product.sellerId;
    Get.to(() => MessagesScreen(remoteUser: widget.product.seller, conversationID: conversationId));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: isProductSeller()
          ? Row(
              children: [
                Expanded(child: CustomText("Is product still available?")),
                Switch(
                  value: _isAvailable,
                  onChanged: (value) async {
                    setState(() => _isAvailable = !_isAvailable);
                    await _commerceController.toggleProduct(widget.product, _isAvailable);
                  },
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      onPressed: _gotoConversationScreen,
                      child: Text(
                        "Chat With Seller",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // SHOW THE FOLLOWING IF USER HAS PHONE NUMBER WHICH IS NOT PROVIDED BY SERVER YET
                // SizedBox(width: 20,),
                // Expanded(
                //     child: SizedBox(
                //       height: 50,
                //       child: TextButton(
                //         style: TextButton.styleFrom(
                //             shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(12)
                //             ),
                //             backgroundColor: AppTheme.primaryColor
                //         ),
                //         onPressed: () {},
                //         child: Text(
                //           "Call Seller",
                //           style: TextStyle(
                //             fontSize: 17,
                //             fontWeight: FontWeight.w500,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     )
                // ),
              ],
            ),
    );
  }
}
