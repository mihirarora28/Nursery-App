import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shops/providers/providers_list.dart';
class EditProductsScreen extends StatefulWidget {

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final imageController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final _form = GlobalKey<FormState>();

@override
  void initState() {
    // TODO: implement initState
  imageController.text = '';
  nameController.text = '';
  descriptionController.text = '';
  priceController.text = '';
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     // final args = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    Map arguments = (ModalRoute.of(context)?.settings.arguments??{}) as Map;
    final productList = Provider.of<Products>(context,listen: false);
    (arguments['title']==null) ?nameController.text='':nameController.text = arguments['title'];
    (arguments['description']==null) ?descriptionController.text='':descriptionController.text = arguments['description'];
    (arguments['imageUrl']==null) ?imageController.text='':imageController.text = arguments['imageUrl'];
    (arguments['price']==null) ?priceController.text='':priceController.text = arguments['price'].toString();
    final check = arguments['edited'];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){

         final ans =   _form.currentState!.validate();
         if(!ans){
           return;
         }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Added!'), backgroundColor: Theme.of(context).primaryColor,duration: Duration(seconds: 2),
            ));
         if(check == null)
            productList.addProduct(DateTime.now().toString(), nameController.text, descriptionController.toString(), double.parse(priceController.text), imageController.text);
         else
           productList.addProduct(arguments['id'], nameController.text, descriptionController.toString(), double.parse(priceController.text), imageController.text);
         Navigator.of(context).pop();

          }, icon: Icon(Icons.save))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Edit Products'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(

                validator: (text){
                  if(nameController.text == null){
                    return 'Please enter some text !!';
                  }
                  if(nameController.text.length == 0){
                    return 'Please enter some text !!';
                  }
                  return null;
                },
                controller: nameController,
                decoration: const  InputDecoration(

                labelText: 'Name',
                hintText: 'What is the Product Name',

                icon: Icon(Icons.shop)
              ),),
              TextFormField(
                validator: (text){
                  if(text == null){
                    return 'Please enter some name !!';
                  }
                  if(text.length == 0){
                    return 'Please enter some name !!';
                  }
                  if(double.tryParse(text) == null){
                    return 'Please enter a valid Price value!';
                  }
                  return null;
                },
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const  InputDecoration(
                    labelText: 'Price',
                    hintText: 'What is the Product\'s Price',
                    icon: Icon(Icons.attach_money)
                ),),
              TextFormField(
                validator: (text){
                  if(text == null){
                    return 'Please enter some description !!';
                  }
                  if(text.length == 0){
                    return 'Please enter some description !!';
                  }
                  return null;
                },
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: const  InputDecoration(
                    labelText: 'Description',
                    hintText: 'Add a Description',
                    icon: Icon(Icons.description)
                ),
                maxLines: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (text){
                        if(text == null){
                          return 'Please enter some Image Url !!';
                        }
                        if(text.length == 0){
                          return 'Please enter some Image Url  !!';
                        }
                        return null;
                      },
                      controller: imageController,
                      onChanged:(string){
                        setState(() {

                        });},

                      keyboardType: TextInputType.multiline,
                      decoration: const  InputDecoration(
                          labelText: 'Image URL',
                          hintText: 'Enter the Image URL',
                          icon: Icon(Icons.image),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: imageController.text == ''?Padding(padding: EdgeInsets.all(2), child: Center(child: Text('No Image'))):Image.network(imageController.text.toString(),fit: BoxFit.fill),
                  ),

                ],

              ),
              SizedBox(height: 30.0,),
              Container(
                width: 20,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('SUBMIT FORM',style: TextStyle(color: Colors.white),),onPressed: (){
                  final ans =   _form.currentState!.validate();
                  if(!ans){
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product Added!'), backgroundColor: Theme.of(context).primaryColor,duration: Duration(seconds: 2),
                  ));
                  if(check == null)
                    productList.addProduct(DateTime.now().toString(), nameController.text, descriptionController.toString(), double.parse(priceController.text), imageController.text);
                  else
                    productList.addProduct(arguments['id'], nameController.text, descriptionController.toString(), double.parse(priceController.text), imageController.text);
                  Navigator.of(context).pop();
                },),
              )
            ],
          ),
        ),
      ),

    );
  }
}
