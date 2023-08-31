import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';

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

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
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

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _form.currentState?.save();
    print('------------------------------------------------------');
    print('------------------------------------------------------');
    print('title: ${_editedProduct.title}');
    print('description: ${_editedProduct.description}');
    print('price: ${_editedProduct.price}');
    print('imageUrl: ${_editedProduct.imageUrl}');
    print('id: ${_editedProduct.id}');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
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
                    );
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
                    );
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
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
                      decoration: const InputDecoration(labelText: 'Image URL'),
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
  }
}
