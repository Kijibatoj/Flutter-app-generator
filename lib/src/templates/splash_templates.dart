class SplashTemplates {
  String generateSplashScreen(String name, Map<String, dynamic> options) {
    final includeAnimations = options['include-animations'] ?? true;
    final animationDuration = options['animation-duration'] ?? 3;
    final checkPermissions = options['check-permissions'] ?? false;
    final appLogo = options['app-logo'] ?? 'assets/images/logo.png';
    
    return '''
import 'package:flutter/material.dart';
${includeAnimations ? "import 'package:flutter/services.dart';" : ""}

class ${_pascalCase(name)} extends StatefulWidget {
  final Future<void> Function() onInit;

  const ${_pascalCase(name)}({super.key, required this.onInit});

  @override
  State<${_pascalCase(name)}> createState() => _${_pascalCase(name)}State();
}

class _${_pascalCase(name)}State extends State<${_pascalCase(name)}>${includeAnimations ? ' with TickerProviderStateMixin' : ''} {
  ${includeAnimations ? '''
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  ''' : ''}

  @override
  void initState() {
    super.initState();
    ${includeAnimations ? '_initAnimations();' : ''}
    _initAsync();
  }

  ${includeAnimations ? '''
  void _initAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: ${animationDuration * 1000}),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: Duration(milliseconds: ${animationDuration * 1000}),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _scaleController.forward();
  }
  ''' : ''}

  Future<void> _initAsync() async {
    ${checkPermissions ? '''
    // Verificar permisos si es necesario
    // await _checkPermissions();
    ''' : ''}
    
    await widget.onInit();
    
    ${includeAnimations ? 'await Future.delayed(Duration(seconds: $animationDuration));' : 'await Future.delayed(Duration(seconds: 2));'}
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  ${checkPermissions ? '''
  Future<void> _checkPermissions() async {
    // Implementar verificación de permisos aquí
    // Por ejemplo: camera, storage, location, etc.
  }
  ''' : ''}

  @override
  void dispose() {
    ${includeAnimations ? '''
    _fadeController.dispose();
    _scaleController.dispose();
    ''' : ''}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ${includeAnimations ? '''
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: 
              ''' : ''}
                  Hero(
                    tag: 'app_logo',
                    child: Image.asset(
                      '$appLogo',
                      height: size.height * 0.15,
                      width: size.width * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),
              ${includeAnimations ? '''
                ),
              ),
              ''' : ''}
              SizedBox(height: size.height * 0.05),
              ${includeAnimations ? '''
              FadeTransition(
                opacity: _fadeAnimation,
                child:
              ''' : ''}
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
              ${includeAnimations ? '''
              ),
              ''' : ''}
              SizedBox(height: size.height * 0.02),
              ${includeAnimations ? '''
              FadeTransition(
                opacity: _fadeAnimation,
                child:
              ''' : ''}
                  Text(
                    'Cargando...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
              ${includeAnimations ? '''
              ),
              ''' : ''}
              ${includeAnimations ? '''
              SizedBox(height: size.height * 0.1),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Preparando tu experiencia',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              ''' : ''}
            ],
          ),
        ),
      ),
    );
  }

  String _pascalCase(String text) {
    return text.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}
''';
  }

  String generateOnboardingScreen(String name, Map<String, dynamic> options) {
    final pagesCount = options['pages-count'] ?? 3;
    final includeSkip = options['include-skip'] ?? true;
    final includeAnimations = options['include-animations'] ?? true;
    final useCubit = options['use-cubit'] ?? true;

    return '''
import 'package:flutter/material.dart';
${useCubit ? "import 'package:flutter_bloc/flutter_bloc.dart';" : ""}
${useCubit ? "import '../cubit/onboarding_cubit.dart';" : ""}

class ${_pascalCase(name)}Screen extends StatefulWidget {
  const ${_pascalCase(name)}Screen({super.key});

  @override
  State<${_pascalCase(name)}Screen> createState() => _${_pascalCase(name)}ScreenState();
}

class _${_pascalCase(name)}ScreenState extends State<${_pascalCase(name)}Screen> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = $pagesCount;

  final List<OnboardingPage> _pages = [
    ${_generateOnboardingPages(pagesCount)}
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    ${useCubit ? '''
    context.read<OnboardingCubit>().completeOnboarding();
    ''' : '''
    // Marcar onboarding como completado
    // SharedPreferences.getInstance().then((prefs) {
    //   prefs.setBool('onboarding_completed', true);
    // });
    '''}
    Navigator.of(context).pushReplacementNamed('/login');
  }

  ${includeSkip ? '''
  void _skipOnboarding() {
    _finishOnboarding();
  }
  ''' : ''}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ${includeSkip ? '''
            _buildSkipButton(theme),
            ''' : 'SizedBox(height: 20),'}
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) => _buildPage(_pages[index]),
              ),
            ),
            _buildBottomSection(theme),
          ],
        ),
      ),
    );
  }

  ${includeSkip ? '''
  Widget _buildSkipButton(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: _skipOnboarding,
          child: Text(
            'Saltar',
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
  ''' : ''}

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ${includeAnimations ? '''
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: 
          ''' : ''}
              Image.asset(
                page.image,
                height: 300,
                fit: BoxFit.contain,
              ),
          ${includeAnimations ? '''
          ),
          ''' : ''}
          SizedBox(height: 40),
          ${includeAnimations ? '''
          TweenAnimationBuilder<Offset>(
            duration: Duration(milliseconds: 800),
            tween: Tween(begin: Offset(0, 50), end: Offset.zero),
            builder: (context, value, child) {
              return Transform.translate(
                offset: value,
                child: Opacity(
                  opacity: 1 - (value.dy / 50),
                  child: child,
                ),
              );
            },
            child:
          ''' : ''}
              Text(
                page.title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
          ${includeAnimations ? '''
          ),
          ''' : ''}
          SizedBox(height: 16),
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _buildPageIndicator(theme),
          SizedBox(height: 24),
          _buildNavigationButtons(theme),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _totalPages,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index 
                ? theme.primaryColor 
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    return Row(
      children: [
        if (_currentPage > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousPage,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: theme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Anterior',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (_currentPage > 0) SizedBox(width: 12),
        Expanded(
          flex: _currentPage > 0 ? 1 : 2,
          child: ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              _currentPage == _totalPages - 1 ? 'Comenzar' : 'Siguiente',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}
''';
  }

  String _generateOnboardingPages(int count) {
    final pages = <String>[];
    
    for (int i = 1; i <= count; i++) {
      pages.add('''
    OnboardingPage(
      title: 'Bienvenido ${i == 1 ? '' : i == count ? 'a comenzar' : 'paso $i'}',
      description: 'Esta es la descripción de la página $i del onboarding. Aquí puedes explicar una característica importante de tu app.',
      image: 'assets/images/onboarding_$i.png',
    )''');
    }
    
    return pages.join(',\n    ');
  }

  String _pascalCase(String text) {
    return text.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}