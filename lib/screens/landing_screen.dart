import 'package:flutter/material.dart';
import 'conversion_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String? selectedCategory;
  final List<String> categories = ['Length', 'Weight', 'Temperature'];

  Widget _buildCategoryCard(String category, IconData icon, bool isTablet) {
    final isSelected = selectedCategory == category;
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedCategory = category;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversionScreen(category: category),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 30 : 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isTablet ? 60 : 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: isTablet ? 20 : 10),
              Text(
                category,
                style: TextStyle(
                  fontSize: isTablet ? 24 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QuickConvert',
                style: TextStyle(
                  fontSize: isTablet ? 48 : 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: padding / 2),
              Text(
                'Convert units quickly and easily',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: padding * 1.5),
              Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to use:',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: padding / 2),
                    Text(
                      '1. Select a conversion category below',
                      style: TextStyle(fontSize: isTablet ? 18 : 14),
                    ),
                    SizedBox(height: padding / 4),
                    Text(
                      '2. Enter the value you want to convert',
                      style: TextStyle(fontSize: isTablet ? 18 : 14),
                    ),
                    SizedBox(height: padding / 4),
                    Text(
                      '3. Choose your units and tap Convert',
                      style: TextStyle(fontSize: isTablet ? 18 : 14),
                    ),
                    SizedBox(height: padding / 4),
                    Text(
                      '4. View your conversion history anytime',
                      style: TextStyle(fontSize: isTablet ? 18 : 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: padding * 1.5),
              Text(
                'Select a Category',
                style: TextStyle(
                  fontSize: isTablet ? 28 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: padding),
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isTablet ? 3 : 2,
                    crossAxisSpacing: padding,
                    mainAxisSpacing: padding,
                    children: [
                      _buildCategoryCard('Length', Icons.straighten, isTablet),
                      _buildCategoryCard(
                        'Weight',
                        Icons.fitness_center,
                        isTablet,
                      ),
                      _buildCategoryCard(
                        'Temperature',
                        Icons.thermostat,
                        isTablet,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
