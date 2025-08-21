class HomeTemplates {
  String generateHomeScreen(String name, Map<String, dynamic> options) {
    final navigationType = options['navigation-type'] ?? 'bottom';
    final tabsCount = options['tabs-count'] ?? 3;
    final includeNotifications = options['include-notifications'] ?? true;
    final includeDrawer = options['include-drawer'] ?? true;
    final usePageView = options['use-pageview'] ?? true;

    return '''
import 'package:flutter/material.dart';
${includeNotifications ? "import 'package:flutter_bloc/flutter_bloc.dart';" : ""}
${includeNotifications ? "import '../cubit/home_cubit.dart';" : ""}
${includeDrawer ? "import '../widgets/app_drawer.dart';" : ""}
import '../widgets/home_section.dart';
${_generateSectionImports(tabsCount)}

class ${_pascalCase(name)}Screen extends StatefulWidget {
  const ${_pascalCase(name)}Screen({super.key});

  @override
  State<${_pascalCase(name)}Screen> createState() => _${_pascalCase(name)}ScreenState();
}

class _${_pascalCase(name)}ScreenState extends State<${_pascalCase(name)}Screen> {
  int _currentIndex = 0;
  ${usePageView ? 'late PageController _pageController;' : ''}

  ${usePageView ? '''
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    ${includeNotifications ? '_initNotifications();' : ''}
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  ''' : includeNotifications ? '''
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }
  ''' : ''}

  ${includeNotifications ? '''
  Future<void> _initNotifications() async {
    await context.read<HomeCubit>().loadNotifications();
  }
  ''' : ''}

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    ${usePageView ? '''
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    ''' : ''}
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Salir de la aplicación?'),
        content: Text('¿Estás seguro que quieres cerrar la aplicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Salir'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        ${includeDrawer ? 'drawer: AppDrawer(),' : ''}
        body: _buildBody(),
        ${(navigationType == 'bottom' || navigationType == 'both') ? 'bottomNavigationBar: _buildBottomNavigation(),' : ''}
        ${navigationType == 'sidebar' ? 'drawer: _buildSideNavigation(),' : ''}
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_getTitle()),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      ${includeNotifications ? '''
      actions: [
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final unreadCount = state.unreadNotifications;
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '\$unreadCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        SizedBox(width: 8),
      ],
      ''' : ''}
    );
  }

  Widget _buildBody() {
    ${usePageView ? '''
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() => _currentIndex = index);
      },
      physics: NeverScrollableScrollPhysics(), // Deshabilitar swipe
      children: _getPages(),
    );
    ''' : '''
    return IndexedStack(
      index: _currentIndex,
      children: _getPages(),
    );
    '''}
  }

  List<Widget> _getPages() {
    return [
      HomeSection(),
      ${_generateSectionWidgets(tabsCount)}
    ];
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Inicio';
      ${_generateTitleCases(tabsCount)}
      default:
        return 'App';
    }
  }

  ${(navigationType == 'bottom' || navigationType == 'both') ? '''
  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        ${_generateBottomNavItems(tabsCount)}
      ],
    );
  }
  ''' : ''}

  ${navigationType == 'sidebar' ? '''
  Widget _buildSideNavigation() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/default-profile.png'),
                ),
                SizedBox(height: 12),
                Text(
                  'Usuario',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'usuario@email.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Inicio'),
            selected: _currentIndex == 0,
            onTap: () {
              _onTabTapped(0);
              Navigator.pop(context);
            },
          ),
          ${_generateSideNavItems(tabsCount)}
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
  ''' : ''}
}
''';
  }

  String generateAppDrawer(String name, Map<String, dynamic> options) {
    return '''
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountName: Text(
              'Usuario',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text('usuario@email.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/default-profile.png'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Ayuda'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/help');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Acerca de'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Mi App',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Mi Empresa',
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24),
          child: Text(
            'Esta aplicación fue creada con Flutter y utiliza arquitectura limpia.',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
''';
  }

  String generateHomeCubit(String name, Map<String, dynamic> options) {
    return '''
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(
    isLoading: false,
    unreadNotifications: 0,
    userName: '',
  ));

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true));
    
    try {
      // Simular carga de notificaciones
      await Future.delayed(Duration(seconds: 1));
      
      // Obtener datos de notificaciones desde repository
      final unreadCount = await _getUnreadNotificationsCount();
      final userName = await _getUserName();
      
      emit(state.copyWith(
        isLoading: false,
        unreadNotifications: unreadCount,
        userName: userName,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<int> _getUnreadNotificationsCount() async {
    // Implementar lógica para obtener notificaciones no leídas
    return 3; // Valor de ejemplo
  }

  Future<String> _getUserName() async {
    // Implementar lógica para obtener nombre del usuario
    return 'Usuario'; // Valor de ejemplo
  }

  void markNotificationAsRead(String notificationId) {
    final currentCount = state.unreadNotifications;
    if (currentCount > 0) {
      emit(state.copyWith(unreadNotifications: currentCount - 1));
    }
  }

  void markAllNotificationsAsRead() {
    emit(state.copyWith(unreadNotifications: 0));
  }

  void updateUserName(String name) {
    emit(state.copyWith(userName: name));
  }
}
''';
  }

  String generateHomeSection(String name, Map<String, dynamic> options) {
    return '''
import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context),
          SizedBox(height: 20),
          _buildQuickActions(context),
          SizedBox(height: 20),
          _buildRecentActivity(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Bienvenido de vuelta!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Espero que tengas un gran día',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              context,
              icon: Icons.add,
              title: 'Nuevo',
              subtitle: 'Crear elemento',
              onTap: () {},
            ),
            _buildActionCard(
              context,
              icon: Icons.search,
              title: 'Buscar',
              subtitle: 'Encontrar elementos',
              onTap: () {},
            ),
            _buildActionCard(
              context,
              icon: Icons.favorite,
              title: 'Favoritos',
              subtitle: 'Ver guardados',
              onTap: () {},
            ),
            _buildActionCard(
              context,
              icon: Icons.settings,
              title: 'Configurar',
              subtitle: 'Ajustes de la app',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad Reciente',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.event,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text('Actividad \${index + 1}'),
                subtitle: Text('Descripción de la actividad reciente'),
                trailing: Text(
                  'Hace \${index + 1}h',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                onTap: () {
                  // Navegar a detalle de actividad
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
''';
  }

  // Métodos auxiliares para generar código dinámico

  String _generateSectionImports(int tabsCount) {
    final imports = <String>[];
    for (int i = 1; i <= tabsCount; i++) {
      imports.add("import '../widgets/section_$i.dart';");
    }
    return imports.join('\n');
  }

  String _generateSectionWidgets(int tabsCount) {
    final widgets = <String>[];
    for (int i = 1; i <= tabsCount; i++) {
      widgets.add("      Section$i(),");
    }
    return widgets.join('\n');
  }

  String _generateTitleCases(int tabsCount) {
    final cases = <String>[];
    for (int i = 1; i <= tabsCount; i++) {
      cases.add('''      case $i:
        return 'Sección $i';''');
    }
    return cases.join('\n');
  }

  String _generateBottomNavItems(int tabsCount) {
    final items = <String>[];
    final icons = ['category_outlined', 'bookmark_outlined', 'person_outlined', 'more_horiz'];
    final activeIcons = ['category', 'bookmark', 'person', 'more_horiz'];
    final labels = ['Categorías', 'Guardados', 'Perfil', 'Más'];

    for (int i = 1; i <= tabsCount; i++) {
      final iconIndex = (i - 1) % icons.length;
      items.add('''        BottomNavigationBarItem(
          icon: Icon(Icons.${icons[iconIndex]}),
          activeIcon: Icon(Icons.${activeIcons[iconIndex]}),
          label: '${labels[iconIndex]}',
        ),''');
    }
    return items.join('\n');
  }

  String _generateSideNavItems(int tabsCount) {
    final items = <String>[];
    final icons = ['category', 'bookmark', 'person', 'more_horiz'];
    final labels = ['Categorías', 'Guardados', 'Perfil', 'Más'];

    for (int i = 1; i <= tabsCount; i++) {
      final iconIndex = (i - 1) % icons.length;
      items.add('''          ListTile(
            leading: Icon(Icons.${icons[iconIndex]}),
            title: Text('${labels[iconIndex]}'),
            selected: _currentIndex == $i,
            onTap: () {
              _onTabTapped($i);
              Navigator.pop(context);
            },
          ),''');
    }
    return items.join('\n');
  }

  String _pascalCase(String text) {
    return text.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}