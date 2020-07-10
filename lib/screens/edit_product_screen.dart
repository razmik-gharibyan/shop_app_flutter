import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // View
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();
  // Controller and Key
  final _imageURLController = TextEditingController();
  final _form = GlobalKey<FormState>();
  // Vars
  var _editedProduct = Product(id: null,title: "",description: "",price: 0.0,imageUrl: "");
  var _isInit = true;
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageURL": "",
  };
  var isLoading = false;

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateImageURL);
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if(_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null) {
        final currentProduct = Provider.of<Products>(context, listen: false)
            .findById(productId);
        _editedProduct = currentProduct;
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageURL": ""
        };
        _isInit = false;
      }
      _imageURLController.text = _editedProduct.imageUrl;
    }
  }

  void _updateImageURL() {
    if(!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm
          )
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) :
      Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(children: [
            TextFormField(
              initialValue: _initValues["title"],
              decoration: InputDecoration(
                labelText: "Title",
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if(value.isEmpty) {
                  return "Please provide Title";
                }else{
                  return null;
                }
              },
              onFieldSubmitted: (value) => {
                FocusScope.of(context).requestFocus(_priceFocusNode)
              },
              onSaved: (value) {
                _editedProduct = Product(
                  id: _editedProduct.id,
                  isFavorite: _editedProduct.isFavorite,
                  title: value,
                  description: _editedProduct.description,
                  price: _editedProduct.price,
                  imageUrl: _editedProduct.imageUrl
                );
              },
            ),
            TextFormField(
              initialValue: _initValues["price"],
              decoration: InputDecoration(
                labelText: "Price",
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              validator: (value) {
                if(value.isEmpty) {
                  return "Please enter a Price";
                }
                if(double.tryParse(value) == null) {
                  return "Please enter a valid number";
                }
                if(double.parse(value) <= 0.0) {
                  return "Please enter a number greater then 0";
                }
                return null;
              },
              onFieldSubmitted: (value) => {
                FocusScope.of(context).requestFocus(_descriptionFocusNode)
              },
              focusNode: _priceFocusNode,
              onSaved: (value) {
                _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl
                );
              },
            ),
            TextFormField(
              initialValue: _initValues["description"],
              decoration: InputDecoration(
                labelText: "Description",
              ),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              validator: (value) {
                if(value.isEmpty) {
                  return "Please enter a Description";
                }
                if(value.length <= 10) {
                  return "Please enter long description";
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl
                );
              },
            ),
            Row(children: [
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(right: 10,top: 8),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey)
                ),
                child: _imageURLController.text.isEmpty ? Text("Enter a URL") : FittedBox(
                  child: Image.network(_imageURLController.text),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: TextFormField(
                  onFieldSubmitted: (_) {
                    setState(() {
                      _saveForm();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Image URL"
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageURLController,
                  focusNode: _imageURLFocusNode,
                  validator: (value) {
                    if(value.isEmpty) {
                      return "Enter image URL";
                    }
                    if(!value.startsWith("http") || !value.startsWith("https")) {
                      return "Enter valid image URL";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: value
                    );
                  },
                ),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.end,)
          ],)
        ),
      ),
    );
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid) {
      return; // Error appeared while validating
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });

    if(_editedProduct.id != null) {
      await Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id, _editedProduct);
      isLoading = false;
      Navigator.of(context).pop();
    }else{
        try {
          await Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("An error occured"),
                content: Text("Something went wrong"),
                actions: [
                  FlatButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ));
        }
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLFocusNode.dispose();
    _imageURLFocusNode.removeListener(_updateImageURL);
    _imageURLController.dispose();
  }
}
