import 'dart:io';

import 'package:dodao/nft_manager/pages/mint.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../blockchain/classes.dart';
import '../blockchain/interface.dart';
import '../blockchain/task_services.dart';
import '../task_dialog/beamer.dart';
import '../wallet/model_view/wallet_model.dart';
import '../widgets/badgetab.dart';
import '../widgets/tags/search_services.dart';
import '../config/theme.dart';
import 'package:flutter/material.dart';

import 'package:webthree/credentials.dart';

import '../widgets/wallet_action_dialog.dart';
import 'collection_services.dart';
import 'pages/treasury.dart';

class CreateOrMint extends StatefulWidget {
  final TokenItem item;
  final String page;
  const CreateOrMint({Key? key, required this.item, required this.page}) : super(key: key);

  @override
  _CreateOrMintState createState() => _CreateOrMintState();
}

class _CreateOrMintState extends State<CreateOrMint> {
  XFile? image;
  final ImagePicker picker = ImagePicker();

  late Status stageUpload = Status.open;
  late Status stageFeatures = Status.await;
  late Status stageCreate = Status.await;
  late Status stageMint = Status.await;

  late bool collectionExist;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   var collectionServices = Provider.of<CollectionServices>(context, listen: false);
    //
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.read<TasksServices>();
    var searchServices = context.watch<SearchServices>();
    var collectionServices = context.watch<CollectionServices>();
    final listenWalletAddress = context.select((WalletModel vm) => vm.state.walletAddress);

    // collectionExist = collectionServices.mintNftTagSelected.collection;
    collectionExist = widget.item.collection;

    if (collectionExist) {
      stageUpload = Status.done;
      stageFeatures = Status.done;
      stageCreate = Status.done;
      stageMint = Status.done;
    } else {
      stageUpload = Status.done;
      stageFeatures = Status.done;
      stageCreate = Status.await;
      stageMint = Status.await;
    }

    // //temporary:
    // if (collectionServices.showMintButton) {
    //   stageCreate = Status.done;
    //   stageMint = Status.await;
    // }

    Future getImage(ImageSource media) async {
      var img = await picker.pickImage(source: media);

      setState(() {
        image = img;
      });
    }

    void uploadAlert() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              title: const Text('Please choose media source'),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Padding(
                  padding: const EdgeInsets.all(33.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          //click this button to upload image from gallery:
                          onPressed: () {
                            Navigator.pop(context);
                            getImage(ImageSource.gallery);
                            stageUpload = Status.done;
                            stageFeatures = Status.open;
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.image),
                              Text('From Gallery'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          //click this button to upload image from camera:
                          onPressed: () {
                            Navigator.pop(context);
                            getImage(ImageSource.camera);
                            stageUpload = Status.done;
                            stageFeatures = Status.open;
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.camera),
                              Text('From Camera'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    final String collectionName = collectionServices.mintNftTagSelected.name;
    final ButtonStyle activeButtonStyle = ElevatedButton.styleFrom(backgroundColor: Colors.deepOrangeAccent);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Top:
          Material(
            type: MaterialType.transparency,
            elevation: 6.0,
            // color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 8, right: 8),
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 250,
                    ),
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Text(
                      collectionName,
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const Spacer(),
                  InkResponse(
                    radius: DodaoTheme.of(context).inkRadius,
                    containedInkWell: false,
                    onTap: () {
                      collectionServices.clearSelectedInManager();
                      searchServices.tagSelection(
                          unselectAll: true,
                          tagName: '', typeSelection: 'mint', tagKey: ''
                      );
                    },
                    child: Icon(
                      Icons.arrow_downward,
                      size: 24,
                      color: DodaoTheme.of(context).secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Body:
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  // height: 160,
                  // width: 160,
                  alignment: Alignment.topLeft,
                  // padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    border: DodaoTheme.of(context).pictureBorderGradient,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            //to show image, you type like this.
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: 160,
                            height: 160,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 150,
                            filterQuality: FilterQuality.medium,
                            isAntiAlias: true,
                          ),
                        ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Upload:
                    Row(
                      children: [
                        // Text(
                        //   'Upload/Generate picture: ',
                        //   style: DodaoTheme.of(context).bodyText1.override(
                        //       fontFamily: 'Inter',
                        //       color: Colors.white
                        //   ),
                        // ),
                        // const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            style: stageUpload == Status.open ? activeButtonStyle : null,
                            onPressed: (stageUpload != Status.done)
                                ? () {
                                    uploadAlert();
                                  }
                                : null,
                            child: Text(
                              'Upload picture',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: DodaoTheme.of(context).buttonTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //Add features:
                    Row(
                      children: [
                        // Text(
                        //   'Add features: ',
                        //   style: DodaoTheme.of(context).bodyText1.override(
                        //       fontFamily: 'Inter',
                        //       color: Colors.white
                        //   ),
                        // ),
                        // const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            style: stageFeatures == Status.open ? activeButtonStyle : null,
                            onPressed: (stageFeatures != Status.done)
                                ? () {
                                    if (stageFeatures == Status.open) {
                                      setState(() {
                                        stageFeatures = Status.done;
                                        stageCreate = Status.open;
                                      });
                                    }
                                  }
                                : null,
                            child: Text(
                              'Add features',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: DodaoTheme.of(context).buttonTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //Create:
                    Row(
                      children: [
                        // Text(
                        //   'Create collection: ',
                        //   style: DodaoTheme.of(context).bodyText1.override(
                        //       fontFamily: 'Inter',
                        //       color: Colors.white
                        //   ),
                        // ),
                        // const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            style: stageCreate == Status.open ? activeButtonStyle : null,
                            // style: activeButtonStyle,
                            // onPressed: (stageCreate != Status.done)
                            //     ? () {
                            //         if (stageCreate == Status.open) {
                            //           setState(() {
                            //             stageCreate = Status.done;
                            //             stageMint = Status.open;
                            //           });
                            //         }
                            //       }
                            //     : null,
                            onPressed: (!collectionExist ) ? () async {
                              // collectionServices.clearSelectedInManager();
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const WalletActionDialog(
                                  nanoId: 'createNFT',
                                  actionName: 'createNFT',
                                  page: 'create_collection',
                                )
                              );
                              String createNftReceipt = await tasksServices.createNft('example.com', collectionName, true);
                              // print('createNftReceipt: $createNftReceipt');
                              if (createNftReceipt.length == 66) {
                                collectionServices.mintNftTagSelected.collection = true;
                                await collectionServices.updateMintNft(collectionServices.mintNftTagSelected);
                                await searchServices.refreshLists('selection');
                                await searchServices.refreshLists('treasury');
                                await searchServices.refreshLists('filter');
                              }
                              // searchServices.tagSelection(typeSelection: 'mint', tagName: '', unselectAll: true, tagKey: '');
                            } : null,
                            child: Text(
                              'Create collection',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: DodaoTheme.of(context).buttonTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        // Text(
                        //   'Mint NFT: ',
                        //   style: DodaoTheme.of(context).bodyText1.override(
                        //       fontFamily: 'Inter',
                        //       color: Colors.white
                        //   ),
                        // ),
                        // const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            style: stageMint == Status.open ? activeButtonStyle : null,
                            // onPressed: (stageMint != Status.done)
                            //     ? () {
                            //         if (stageMint == Status.open) {
                            //           setState(() {
                            //             stageMint = Status.done;
                            //           });
                            //         }
                            //       }
                            //     : null,
                            onPressed: (collectionExist ) ? () {
                              if (listenWalletAddress != null) {
                                final List<EthereumAddress> address = [listenWalletAddress!];
                                final List<BigInt> quantities = [BigInt.from(1)];

                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => const WalletActionDialog(
                                      nanoId: 'mintNonFungible',
                                      actionName: 'mintNonFungible',
                                    )
                                );

                                tasksServices.mintNonFungibleByName(collectionName, address, quantities);

                              }
                            } : null,
                            child: Text(
                              'Mint',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(color: DodaoTheme.of(context).buttonTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
