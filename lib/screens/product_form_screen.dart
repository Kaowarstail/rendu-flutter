import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../services/product_provider.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;
  final bool isEdit;

  const ProductFormScreen({Key? key, this.product, this.isEdit = false}) : super(key: key);

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
      _imageController.text = widget.product!.image;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Fermer le clavier en tapant en dehors
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEdit ? 'Modifier le produit' : 'Ajouter un produit'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du produit',
                          prefixIcon: Icon(Icons.inventory_2),
                          hintText: 'Ex: Smartphone 128Go',
                        ),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description (optionnel)',
                          prefixIcon: Icon(Icons.description),
                          hintText: 'Décrivez votre produit...',
                          alignLabelWithHint: true,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        // La description est maintenant optionnelle
                        validator: (value) {
                          return null; // Accepte les descriptions vides
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Prix',
                          prefixIcon: const Icon(Icons.euro),
                          suffixText: '€',
                          suffixStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: '0.00',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un prix';
                          }
                          
                          if (double.tryParse(value) == null) {
                            return 'Veuillez entrer un prix valide';
                          }
                          
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_imageController.text.isNotEmpty && Uri.tryParse(_imageController.text)!.isAbsolute)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      _imageController.text,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.broken_image, color: Colors.red, size: 60),
                                              SizedBox(height: 8),
                                              Text('URL d\'image invalide',
                                                  style: TextStyle(fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'Prévisualisation',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          TextFormField(
                            controller: _imageController,
                            decoration: const InputDecoration(
                              labelText: 'URL de l\'image',
                              prefixIcon: Icon(Icons.image),
                              hintText: 'https://exemple.com/image.jpg',
                            ),
                            keyboardType: TextInputType.url,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer une URL';
                              }
                              
                              if (!Uri.tryParse(value)!.isAbsolute) {
                                return 'Veuillez entrer une URL valide';
                              }
                              
                              return null;
                            },
                            onChanged: (value) {
                              // Force une reconstruction du widget pour mettre à jour la prévisualisation
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: productProvider.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Masquer le clavier
                                    FocusScope.of(context).unfocus();
                                    
                                    final product = Product(
                                      uuid: widget.product?.uuid ?? '',
                                      name: _nameController.text,
                                      description: _descriptionController.text,
                                      price: double.parse(_priceController.text),
                                      image: _imageController.text,
                                    );
                                    
                                    bool success;
                                    if (widget.isEdit) {
                                      success = await productProvider.updateProduct(product);
                                    } else {
                                      success = await productProvider.createProduct(product);
                                    }
                                    
                                    if (success && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.check_circle, color: Colors.white),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Text(widget.isEdit 
                                                  ? 'Produit modifié avec succès' 
                                                  : 'Produit ajouté avec succès')
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.green,
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    } else if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.error_outline, color: Colors.white),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Text(productProvider.error),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.all(16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: productProvider.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(widget.isEdit ? Icons.save : Icons.add_circle),
                                    const SizedBox(width: 12),
                                    Text(
                                      widget.isEdit ? 'Enregistrer les modifications' : 'Ajouter ce produit',
                                      style: const TextStyle(
                                        fontSize: 16, 
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      if (widget.isEdit)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: TextButton.icon(
                            onPressed: productProvider.isLoading
                                ? null 
                                : () {
                                    Navigator.pop(context);
                                  },
                            icon: const Icon(Icons.cancel),
                            label: const Text('Annuler les modifications'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey[700],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (productProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Card(
                      elevation: 8,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ),
    );
  }
}
