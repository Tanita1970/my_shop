import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode(); // Узел фокусировки
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute
          .of(context)
          ?.settings
          .arguments;
      if (productId is String) {
        if (productId != '') {
          _editedProduct =
              Provider.of<Products>(context, listen: false).findById(productId);
          _initValues = {
            'title': _editedProduct.title,
            'description': _editedProduct.description,
            'price': _editedProduct.price.toString(),
            // 'imageUrl': _editedProduct.imageUrl,
            'imageUrl': '',
          };
          _imageUrlController.text = _editedProduct.imageUrl;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.png'))) {
        print('СРАБОТАЛО!!!!!!!!!!!!!');
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != '') {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text('Something went wrong.'),
              actions: [
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

// Во избежании утечки памяти, обязательно узлы фокусировки
// надо уничтожить
@override
void dispose() {
  _imageUrlFocusNode.removeListener(_updateImageUrl);
  _priceFocusNode.dispose();
  _descriptionFocusNode.dispose();
  _imageUrlController.dispose();
  _imageUrlFocusNode.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Edit Product'),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveForm,
        )
      ],
    ),
    body: _isLoading
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _form,
        child: ListView(
          children: [
            TextFormField(
              initialValue: _initValues['title'],
              decoration: const InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Введите название!';
                }
                return null; // Означает, что нет ошибки
              },
              onSaved: (newValue) {
                if (newValue != null) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: newValue,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                }
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
              decoration: const InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context)
                    .requestFocus(_descriptionFocusNode);
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Введите цену!';
                }
                if (value != null && double.tryParse(value) == null) {
                  return 'Введите цену правильно!';
                }
                if (value != null && double.parse(value) <= 0) {
                  return 'Введите положительное число!';
                }
                return null; // Означает, что нет ошибки
              },
              onSaved: (newValue) {
                if (newValue != null) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(newValue),
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                }
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
              decoration:
              const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              // textInputAction: TextInputAction.next,
              // textInputAction убираем, так как всё равно при мультистрочном вводе
              // он не будет работать
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Введите описание!';
                }
                if (value != null && value.length < 10) {
                  return 'Описание должно быть более 10 символов';
                }
                return null; // Означает, что нет ошибки
              },
              onSaved: (newValue) {
                if (newValue != null) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: newValue,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                }
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: _imageUrlController.text.isEmpty
                      ? const Text('Enter a URL')
                      : FittedBox(
                    child: Image.network(
                      _imageUrlController.text,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    // initialValue: _initValues['imageUrl'],
                    decoration:
                    const InputDecoration(labelText: 'Image URL'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    focusNode: _imageUrlFocusNode,
                    onFieldSubmitted: (_) => _saveForm(),
                    // onEditingComplete: () {
                    //   setState(() {});
                    // },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Введите URL картинки!';
                      }
                      if (!value.startsWith('http') &&
                          !value.startsWith('https')) {
                        return 'Пожалуйста введите корректный адрес картинки!';
                      }
                      if (!value.endsWith('.jpg') &&
                          !value.endsWith('.jpeg') &&
                          !value.endsWith('.png')) {
                        return 'Пожалуйста введите корректный тип картинки!';
                      }
                      return null; // Означает, что нет ошибки
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: newValue,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}}
