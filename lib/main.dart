import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:badges/badges.dart' as badges;

// ─────────────────────────────────────────────
//  THEME & CONSTANTS
// ─────────────────────────────────────────────

class AppColors {
  static const bg        = Color(0xFF0D0D0D);
  static const surface   = Color(0xFF1A1A1A);
  static const card      = Color(0xFF1E1E1E);
  static const cardHigh  = Color(0xFF252525);
  static const accent    = Color(0xFF6C63FF);
  static const accentAlt = Color(0xFF00C896);
  static const text      = Color(0xFFE0E0E0);
  static const textMuted = Color(0xFF888888);
  static const border    = Color(0xFF2C2C2C);
  static const error     = Color(0xFFFF4F4F);
  static const star      = Color(0xFFFFD166);
}

ThemeData buildTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.accent,
      secondary: AppColors.accentAlt,
      surface: AppColors.surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: AppColors.text),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.card,
      selectedColor: AppColors.accent,
      labelStyle: GoogleFonts.poppins(color: AppColors.text, fontSize: 12),
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String brand;
  final String description;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String category;
  final List<String> tags;
  final bool isNew;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.category,
    required this.tags,
    this.isNew = false,
    this.stock = 10,
  });

  double get discountPercent =>
      originalPrice > price ? ((originalPrice - price) / originalPrice * 100) : 0;
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

// ─────────────────────────────────────────────
//  PRODUCT DATA
// ─────────────────────────────────────────────

final List<Product> kProducts = [
  const Product(
    id: '1',
    name: 'Headphones Pro X',
    brand: 'SoundCraft',
    description:
        'Experience studio-quality audio with our flagship wireless headphones. Featuring 40mm custom drivers, ANC, and 30-hour battery life. The premium memory foam ear cushions provide all-day comfort while the foldable design ensures portability.',
    price: 3999,
    originalPrice: 5999,
    rating: 4.8,
    reviewCount: 2341,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrzLQkolLCDocY-mohu060ml7f_iRRG5RYiA&s',
    category: 'Electronics',
    tags: ['Audio', 'Wireless', 'ANC'],
    isNew: false,
    stock: 15,
  ),
  const Product(
    id: '2',
    name: 'Smart Watch Ultra',
    brand: 'ChronoTech',
    description:
        'Track your fitness, manage notifications, and monitor your health with the Ultra. Featuring an always-on AMOLED display, GPS, ECG, and 7-day battery life in a titanium case with sapphire crystal glass.',
    price: 2999,
    originalPrice: 3499,
    rating: 4.6,
    reviewCount: 1876,
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
    category: 'Electronics',
    tags: ['Wearable', 'Health', 'GPS'],
    isNew: true,
    stock: 8,
  ),
  const Product(
    id: '3',
    name: 'Leather Bag',
    brand: 'Vogue Studio',
    description:
        'Crafted from full-grain Italian leather, this minimalist tote features a spacious interior, internal organizer pockets, and a detachable shoulder strap. A timeless piece that transcends seasons.',
    price: 1899,
    originalPrice: 2499,
    rating: 4.9,
    reviewCount: 943,
    imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600',
    category: 'Fashion',
    tags: ['Leather', 'Tote', 'Premium'],
    isNew: false,
    stock: 20,
  ),
  const Product(
    id: '4',
    name: 'Keyboard TKL',
    brand: 'KeyForge',
    description:
        'Tenkeyless mechanical keyboard with Cherry MX Red switches, per-key RGB lighting, aluminum top plate, and double-shot PBT keycaps. USB-C detachable cable. Perfect for both gaming and productivity.',
    price: 1199,
    originalPrice: 1499,
    rating: 4.7,
    reviewCount: 3210,
    imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600',
    category: 'Electronics',
    tags: ['Gaming', 'Keyboard', 'RGB'],
    isNew: true,
    stock: 25,
  ),
  const Product(
    id: '5',
    name: 'Scented Candle Set',
    brand: 'Lumière Home',
    description:
        'A curated set of 3 luxury soy-wax candles in hand-blown glass vessels. Scents: Oud & Amber, Vetiver & Cedar, White Tea & Lemon. 50+ hour burn time each. Perfect for creating an ambiance.',
    price: 499,
    originalPrice: 999,
    rating: 4.5,
    reviewCount: 521,
    imageUrl: 'https://www.colishco.com/cdn/shop/files/LILLY.png?v=1719908086',
    category: 'Home',
    tags: ['Candle', 'Soy', 'Gift Set'],
    isNew: false,
    stock: 40,
  ),
  const Product(
    id: '6',
    name: 'Running Sneakers X9',
    brand: 'SwiftStride',
    description:
        'Engineered for speed and comfort. Featuring a carbon fiber plate, reactive foam midsole, and Flyknit upper, these sneakers offer race-day performance in everyday wear. Available in multiple colorways.',
    price: 799,
    originalPrice: 1199,
    rating: 4.4,
    reviewCount: 1654,
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
    category: 'Fashion',
    tags: ['Running', 'Carbon', 'Knit'],
    isNew: false,
    stock: 12,
  ),
  const Product(
    id: '7',
    name: 'Pour-Over Coffee Kit',
    brand: 'BrewMaster',
    description:
        'The complete pour-over brewing experience. Includes borosilicate glass dripper, stainless steel filters, gooseneck kettle, and a hand burr grinder. Master the art of precision coffee brewing.',
    price: 1999,
    originalPrice: 2999,
    rating: 4.8,
    reviewCount: 789,
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
    category: 'Home',
    tags: ['Coffee', 'Pour Over', 'Kit'],
    isNew: true,
    stock: 18,
  ),
  const Product(
    id: '8',
    name: 'Portable SSD 2TB',
    brand: 'DataVault',
    description:
        'Ultra-compact 2TB SSD with USB 3.2 Gen 2 delivering up to 1,050 MB/s read speeds. IP55-rated for dust and water resistance. Fits in your pocket yet packs a punch for creatives on the go.',
    price: 799,
    originalPrice: 1199,
    rating: 4.7,
    reviewCount: 2089,
    imageUrl: 'https://www.shutterstock.com/image-photo/pair-black-golden-ssd-solid-260nw-1715677042.jpg',
    category: 'Electronics',
    tags: ['Storage', 'SSD', 'Portable'],
    isNew: false,
    stock: 30,
  ),
];

const List<String> kCategories = [
  'All',
  'Electronics',
  'Fashion',
  'Home',
];

// ─────────────────────────────────────────────
//  STATE MANAGEMENT
// ─────────────────────────────────────────────

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => Map.unmodifiable(_items);
  int get itemCount => _items.values.fold(0, (s, i) => s + i.quantity);
  double get total => _items.values.fold(0, (s, i) => s + i.product.price * i.quantity);

  bool contains(String id) => _items.containsKey(id);
  int quantityOf(String id) => _items[id]?.quantity ?? 0;

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void incrementQuantity(String id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String id) {
    if (_items.containsKey(id)) {
      if (_items[id]!.quantity <= 1) {
        _items.remove(id);
      } else {
        _items[id]!.quantity--;
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class WishlistProvider extends ChangeNotifier {
  final Set<String> _wishlist = {};

  bool isWishlisted(String id) => _wishlist.contains(id);
  int get count => _wishlist.length;

  void toggle(String id) {
    if (_wishlist.contains(id)) {
      _wishlist.remove(id);
    } else {
      _wishlist.add(id);
    }
    notifyListeners();
  }

  List<Product> wishlistedProducts() =>
      kProducts.where((p) => _wishlist.contains(p.id)).toList();
}

// ─────────────────────────────────────────────
//  ENTRY POINT
// ─────────────────────────────────────────────

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: const ShoppingApp(),
    ),
  );
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopHub',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const MainShell(),
      onGenerateRoute: (settings) {
        if (settings.name == '/product') {
          final product = settings.arguments as Product;
          return PageRouteBuilder(
            pageBuilder: (_, a, sa) => ProductDetailPage(product: product),
            transitionsBuilder: (_, a, __, child) {
              return FadeTransition(
                opacity: CurvedAnimation(parent: a, curve: Curves.easeInOut),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 350),
          );
        }
        if (settings.name == '/cart') {
          return PageRouteBuilder(
            pageBuilder: (_, a, __) => const CartPage(),
            transitionsBuilder: (_, a, __, child) {
              final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic));
              return SlideTransition(position: a.drive(tween), child: child);
            },
            transitionDuration: const Duration(milliseconds: 350),
          );
        }
        if (settings.name == '/wishlist') {
          return PageRouteBuilder(
            pageBuilder: (_, a, __) => const WishlistPage(),
            transitionsBuilder: (_, a, __, child) {
              final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOutCubic));
              return SlideTransition(position: a.drive(tween), child: child);
            },
          );
        }
        return null;
      },
    );
  }
}

// ─────────────────────────────────────────────
//  MAIN SHELL (Bottom Nav)
// ─────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _pages = const [
    HomePage(),
    WishlistPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    return Consumer2<CartProvider, WishlistProvider>(
      builder: (ctx, cart, wish, _) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(icon: Icons.home_rounded, label: 'Home', index: 0, selected: _currentIndex == 0, onTap: _setIndex),
                  _NavItemBadge(icon: Icons.favorite_rounded, label: 'Wishlist', index: 1, selected: _currentIndex == 1, badgeCount: wish.count, onTap: _setIndex),
                  _NavItemBadge(icon: Icons.shopping_bag_rounded, label: 'Cart', index: 2, selected: _currentIndex == 2, badgeCount: cart.itemCount, onTap: _setIndex),
                  _NavItem(icon: Icons.person_rounded, label: 'Profile', index: 3, selected: _currentIndex == 3, onTap: _setIndex),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _setIndex(int i) => setState(() => _currentIndex = i);
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool selected;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: selected
            ? BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: selected ? AppColors.accent : AppColors.textMuted, size: 22),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.accent : AppColors.textMuted,
            ),
          ),
        ]),
      ),
    );
  }
}

class _NavItemBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final bool selected;
  final int badgeCount;
  final ValueChanged<int> onTap;

  const _NavItemBadge({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: selected
            ? BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          badges.Badge(
            showBadge: badgeCount > 0,
            badgeContent: Text(
              '$badgeCount',
              style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            ),
            badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.accent, padding: EdgeInsets.all(4)),
            child: Icon(icon, color: selected ? AppColors.accent : AppColors.textMuted, size: 22),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.accent : AppColors.textMuted,
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HOME PAGE
// ─────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;
  late AnimationController _fadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
      _fadeCtrl.forward();
    });
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  List<Product> get _filtered {
    return kProducts.where((p) {
      final matchCat = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery) ||
          p.brand.toLowerCase().contains(_searchQuery) ||
          p.tags.any((t) => t.toLowerCase().contains(_searchQuery));
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          _buildSearchBar(),
          _buildCategoryChips(),
          _buildBanner(),
          _isLoading ? _buildShimmerGrid() : _buildProductGrid(),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      title: Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent, AppColors.accentAlt],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          'ShopHub',
          style: GoogleFonts.poppins(
            color: AppColors.text,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
      ]),
      actions: [
        Consumer<WishlistProvider>(
          builder: (_, wish, __) => _AppBarIcon(
            icon: Icons.favorite_border_rounded,
            badge: wish.count,
            onTap: () => Navigator.pushNamed(context, '/wishlist'),
          ),
        ),
        Consumer<CartProvider>(
          builder: (_, cart, __) => _AppBarIcon(
            icon: Icons.shopping_bag_outlined,
            badge: cart.itemCount,
            onTap: () => Navigator.pushNamed(context, '/cart'),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  SliverToBoxAdapter _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _searchCtrl,
            style: GoogleFonts.poppins(color: AppColors.text, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search products, brands...',
              hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
              suffixIcon: _searchQuery.isNotEmpty
                  ? GestureDetector(
                      onTap: () => _searchCtrl.clear(),
                      child: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildCategoryChips() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 52,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: kCategories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final cat = kCategories[i];
            final selected = _selectedCategory == cat;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(colors: [AppColors.accent, Color(0xFF9B59B6)])
                      : null,
                  color: selected ? null : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? Colors.transparent : AppColors.border,
                  ),
                ),
                child: Text(
                  cat,
                  style: GoogleFonts.poppins(
                    color: selected ? Colors.white : AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBanner() {
    if (_searchQuery.isNotEmpty || _selectedCategory != 'All') {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
          child: Text(
            '${_filtered.length} result${_filtered.length != 1 ? 's' : ''} found',
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3B36B5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.07),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -30,
              child: Container(
                width: 90,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'LIMITED OFFER',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Up to 30% off\nPremium Electronics',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Shop Now →',
                      style: GoogleFonts.poppins(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  SliverPadding _buildShimmerGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, __) => _ShimmerCard(),
          childCount: 6,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
      ),
    );
  }

  SliverPadding _buildProductGrid() {
    final products = _filtered;
    if (products.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.all(40),
        sliver: SliverToBoxAdapter(
          child: Column(children: [
            const Icon(Icons.search_off_rounded, color: AppColors.textMuted, size: 64),
            const SizedBox(height: 12),
            Text(
              'No products found',
              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 16),
            ),
          ]),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, i) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: _fadeCtrl,
                curve: Interval(
                  (i / products.length) * 0.5,
                  math.min(1.0, (i / products.length) * 0.5 + 0.5),
                  curve: Curves.easeOut,
                ),
              ),
              child: ProductCard(product: products[i]),
            );
          },
          childCount: products.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
      ),
    );
  }
}

class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final int badge;
  final VoidCallback onTap;
  const _AppBarIcon({required this.icon, required this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: badges.Badge(
          showBadge: badge > 0,
          badgeContent: Text(
            '$badge',
            style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          badgeStyle: const badges.BadgeStyle(badgeColor: AppColors.accent, padding: EdgeInsets.all(4)),
          child: Icon(icon, color: AppColors.text, size: 24),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PRODUCT CARD
// ─────────────────────────────────────────────

class ProductCard extends StatefulWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnim = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  void _openDetail() {
    Navigator.pushNamed(context, '/product', arguments: widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Consumer2<CartProvider, WishlistProvider>(
      builder: (ctx, cart, wish, _) {
        return GestureDetector(
          onTapDown: (_) => _pressCtrl.forward(),
          onTapUp: (_) { _pressCtrl.reverse(); _openDetail(); },
          onTapCancel: () => _pressCtrl.reverse(),
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    flex: 5,
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Hero(
                          tag: 'product_image_${p.id}',
                          child: Image.network(
                            p.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, progress) {
                              if (progress == null) return child;
                              return Container(color: AppColors.cardHigh);
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.cardHigh,
                              child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      ),
                      // Badges
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (p.isNew)
                              _Badge(label: 'NEW', color: AppColors.accentAlt),
                            if (p.discountPercent > 0)
                              _Badge(label: '-${p.discountPercent.toInt()}%', color: AppColors.error),
                          ],
                        ),
                      ),
                      // Wishlist button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _WishlistButton(productId: p.id),
                      ),
                    ]),
                  ),
                  // Info
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.brand.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: AppColors.textMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: AppColors.text,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.star_rounded, color: AppColors.star, size: 12),
                            const SizedBox(width: 3),
                            Text(
                              p.rating.toString(),
                              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${p.reviewCount})',
                              style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 9),
                            ),
                          ]),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${p.price.toStringAsFixed(2)}Rs',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.accent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (p.discountPercent > 0)
                                    Text(
                                      '${p.originalPrice.toStringAsFixed(2)}Rs',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.textMuted,
                                        fontSize: 9,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                              _CartButton(product: p),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _WishlistButton extends StatefulWidget {
  final String productId;
  const _WishlistButton({required this.productId});

  @override
  State<_WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<_WishlistButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (ctx, wish, _) {
        final wishlisted = wish.isWishlisted(widget.productId);
        return GestureDetector(
          onTap: () {
            wish.toggle(widget.productId);
            _ctrl.forward(from: 0);
          },
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                wishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: wishlisted ? AppColors.error : AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CartButton extends StatefulWidget {
  final Product product;
  const _CartButton({required this.product});

  @override
  State<_CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<_CartButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.0), weight: 50),
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        final inCart = cart.contains(widget.product.id);
        return ScaleTransition(
          scale: _scaleAnim,
          child: GestureDetector(
            onTap: () {
              _ctrl.forward(from: 0);
              cart.addItem(widget.product);
              _showAddedSnack(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: inCart
                    ? const LinearGradient(colors: [AppColors.accentAlt, Color(0xFF00A882)])
                    : const LinearGradient(colors: [AppColors.accent, Color(0xFF9B59B6)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                inCart ? Icons.check_rounded : Icons.add_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddedSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '${widget.product.name} added to cart',
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ]),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// Shimmer loading card
class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.card,
      highlightColor: AppColors.cardHigh,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.cardHigh,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: 8, width: 60, color: AppColors.cardHigh, margin: const EdgeInsets.only(bottom: 6)),
                Container(height: 10, width: double.infinity, color: AppColors.cardHigh, margin: const EdgeInsets.only(bottom: 4)),
                Container(height: 10, width: 80, color: AppColors.cardHigh, margin: const EdgeInsets.only(bottom: 12)),
                Container(height: 8, width: 40, color: AppColors.cardHigh),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(height: 16, width: 60, color: AppColors.cardHigh),
                  Container(height: 30, width: 30, color: AppColors.cardHigh),
                ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PRODUCT DETAIL PAGE
// ─────────────────────────────────────────────

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _slideAnim = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _slideCtrl, curve: Curves.easeIn);
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(p),
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: _buildDetail(p),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(p),
    );
  }

  SliverAppBar _buildSliverAppBar(Product p) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      backgroundColor: AppColors.bg,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
        ),
      ),
      actions: [
        Consumer<WishlistProvider>(
          builder: (ctx, wish, _) {
            final wishlisted = wish.isWishlisted(p.id);
            return GestureDetector(
              onTap: () => wish.toggle(p.id),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.card.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    wishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: wishlisted ? AppColors.error : AppColors.text,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 4),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'product_image_${p.id}',
              child: Image.network(
                p.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) =>
                    progress == null ? child : Container(color: AppColors.cardHigh),
                errorBuilder: (_, __, ___) => Container(color: AppColors.cardHigh),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.bg.withOpacity(0.8),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(Product p) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Brand & category
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Text(
              p.category,
              style: GoogleFonts.poppins(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          if (p.isNew)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentAlt.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accentAlt.withOpacity(0.3)),
              ),
              child: Text(
                'NEW ARRIVAL',
                style: GoogleFonts.poppins(color: AppColors.accentAlt, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
        ]),
        const SizedBox(height: 12),

        // Name
        Text(
          p.name,
          style: GoogleFonts.poppins(
            color: AppColors.text,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'by ${p.brand}',
          style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 16),

        // Rating
        Row(children: [
          RatingBar.builder(
            initialRating: p.rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 18,
            ignoreGestures: true,
            itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppColors.star),
            onRatingUpdate: (_) {},
          ),
          const SizedBox(width: 8),
          Text(
            '${p.rating}',
            style: GoogleFonts.poppins(color: AppColors.text, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            '(${p.reviewCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} reviews)',
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12),
          ),
        ]),
        const SizedBox(height: 20),

        // Price
        Row(children: [
          Text(
            '${p.price.toStringAsFixed(2)}Rs',
            style: GoogleFonts.poppins(
              color: AppColors.accent,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (p.discountPercent > 0) ...[
            const SizedBox(width: 10),
            Text(
              '${p.originalPrice.toStringAsFixed(2)}Rs',
              style: GoogleFonts.poppins(
                color: AppColors.textMuted,
                fontSize: 16,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${p.discountPercent.toInt()}% OFF',
                style: GoogleFonts.poppins(color: AppColors.error, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ]),
        const SizedBox(height: 20),

        // Divider
        Container(height: 0.5, color: AppColors.border),
        const SizedBox(height: 20),

        // Description
        Text(
          'About This Product',
          style: GoogleFonts.poppins(
            color: AppColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          p.description,
          style: GoogleFonts.poppins(
            color: AppColors.textMuted,
            fontSize: 14,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 20),

        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: p.tags.map((tag) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              '# $tag',
              style: GoogleFonts.poppins(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 20),

        // Stock
        Row(children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: p.stock > 5 ? AppColors.accentAlt : AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            p.stock > 5 ? 'In Stock (${p.stock} available)' : 'Low Stock — only ${p.stock} left!',
            style: GoogleFonts.poppins(
              color: p.stock > 5 ? AppColors.accentAlt : AppColors.error,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _buildBottomBar(Product p) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        final inCart = cart.contains(p.id);
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: const Border(top: BorderSide(color: AppColors.border, width: 0.5)),
          ),
          child: Row(children: [
            // Quick wishlist
            Consumer<WishlistProvider>(
              builder: (ctx, wish, _) => GestureDetector(
                onTap: () => wish.toggle(p.id),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    wish.isWishlisted(p.id) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: wish.isWishlisted(p.id) ? AppColors.error : AppColors.textMuted,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Add to cart
            Expanded(
              child: _AddToCartButton(product: p, inCart: inCart, cart: cart),
            ),
          ]),
        );
      },
    );
  }
}

class _AddToCartButton extends StatefulWidget {
  final Product product;
  final bool inCart;
  final CartProvider cart;
  const _AddToCartButton({required this.product, required this.inCart, required this.cart});

  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.93), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.93, end: 1.0), weight: 50),
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: () {
          _ctrl.forward(from: 0);
          widget.cart.addItem(widget.product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.inCart ? 'Quantity updated in cart!' : '${widget.product.name} added to cart!',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
              backgroundColor: AppColors.accentAlt,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 52,
          decoration: BoxDecoration(
            gradient: widget.inCart
                ? const LinearGradient(colors: [AppColors.accentAlt, Color(0xFF00A882)])
                : const LinearGradient(colors: [AppColors.accent, Color(0xFF9B59B6)]),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: (widget.inCart ? AppColors.accentAlt : AppColors.accent).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              widget.inCart ? Icons.check_circle_outline_rounded : Icons.shopping_bag_outlined,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              widget.inCart ? 'Add More to Cart' : 'Add to Cart',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CART PAGE
// ─────────────────────────────────────────────

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 20),
        ),
        centerTitle: false,
        actions: [
          Consumer<CartProvider>(
            builder: (ctx, cart, _) {
              if (cart.items.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () => _confirmClear(ctx, cart),
                child: Text(
                  'Clear All',
                  style: GoogleFonts.poppins(color: AppColors.error, fontSize: 13),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (ctx, cart, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textMuted, size: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: GoogleFonts.poppins(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Looks like you haven\'t added\nanything to your cart yet.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14, height: 1.5),
                ),
              ]),
            );
          }

          final items = cart.items.values.toList();
          return Column(children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _CartItemTile(item: items[i]),
              ),
            ),
            _CartSummary(cart: cart),
          ]);
        },
      ),
    );
  }

  void _confirmClear(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear Cart?', style: GoogleFonts.poppins(color: AppColors.text, fontWeight: FontWeight.w700)),
        content: Text('Remove all items from your cart?', style: GoogleFonts.poppins(color: AppColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () { cart.clear(); Navigator.pop(context); },
            child: Text('Clear', style: GoogleFonts.poppins(color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Row(children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                p.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80, height: 80,
                  color: AppColors.cardHigh,
                  child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textMuted),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  p.brand,
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 10, letterSpacing: 0.8),
                ),
                Text(
                  p.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3),
                ),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    '${(p.price * item.quantity).toStringAsFixed(2)}Rs',
                    style: GoogleFonts.poppins(color: AppColors.accent, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  // Qty control
                  Row(children: [
                    _QtyBtn(
                      icon: Icons.remove_rounded,
                      onTap: () => cart.decrementQuantity(p.id),
                    ),
                    Container(
                      width: 32,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: GoogleFonts.poppins(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                    _QtyBtn(
                      icon: Icons.add_rounded,
                      onTap: () => cart.incrementQuantity(p.id),
                    ),
                  ]),
                ]),
              ]),
            ),
            // Remove
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => cart.removeItem(p.id),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.close_rounded, color: AppColors.error, size: 16),
                  ),
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: AppColors.cardHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.text, size: 14),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartProvider cart;
  const _CartSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final shipping = cart.total > 100 ? 0.0 : 9.99;
    final tax = cart.total * 0.08;
    final grandTotal = cart.total + shipping + tax;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Column(children: [
        _SummaryRow(label: 'Subtotal', value: '${cart.total.toStringAsFixed(2)}Rs'),
        const SizedBox(height: 6),
        _SummaryRow(
          label: 'Shipping',
          value: shipping == 0 ? 'FREE' : '${shipping.toStringAsFixed(2)}Rs',
          valueColor: shipping == 0 ? AppColors.accentAlt : null,
        ),
        const SizedBox(height: 6),
        _SummaryRow(label: 'Tax (8%)', value: '${tax.toStringAsFixed(2)}Rs'),
        const SizedBox(height: 12),
        Container(height: 0.5, color: AppColors.border),
        const SizedBox(height: 12),
        _SummaryRow(
          label: 'Total',
          value: '${grandTotal.toStringAsFixed(2)}Rs',
          isTotal: true,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.accent, Color(0xFF9B59B6)]),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => _showCheckoutDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Proceed to Checkout  →',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ),
        if (cart.total <= 100) ...[
          const SizedBox(height: 8),
          Text(
            'Add ${((100 - cart.total).toStringAsFixed(2))}Rs more for free shipping!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ]),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [AppColors.accentAlt, Color(0xFF00A882)]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 16),
          Text('Order Placed! 🎉', style: GoogleFonts.poppins(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'This is a demo app. In production, you\'d be redirected to the payment gateway.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13, height: 1.5),
          ),
        ]),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<CartProvider>(context, listen: false).clear();
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Continue Shopping', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;
  const _SummaryRow({required this.label, required this.value, this.valueColor, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          color: isTotal ? AppColors.text : AppColors.textMuted,
          fontSize: isTotal ? 16 : 13,
          fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      Text(
        value,
        style: GoogleFonts.poppins(
          color: valueColor ?? (isTotal ? AppColors.accent : AppColors.text),
          fontSize: isTotal ? 18 : 13,
          fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
    ]);
  }
}

// ─────────────────────────────────────────────
//  WISHLIST PAGE
// ─────────────────────────────────────────────

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: Consumer<WishlistProvider>(
        builder: (ctx, wish, _) {
          final products = wish.wishlistedProducts();
          if (products.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(color: AppColors.card, shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border_rounded, color: AppColors.textMuted, size: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: GoogleFonts.poppins(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the ♥ on any product\nto save it here.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14, height: 1.5),
                ),
              ]),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (_, i) => ProductCard(product: products[i]),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROFILE PAGE
// ─────────────────────────────────────────────

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: AppColors.bg,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1040), AppColors.bg],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentAlt]),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Alex Johnson',
                    style: GoogleFonts.poppins(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'alex.johnson@email.com',
                    style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
                  ),
                ]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Consumer2<CartProvider, WishlistProvider>(
                builder: (ctx, cart, wish, _) {
                  return Column(children: [
                    Row(children: [
                      _StatCard(label: 'Orders', value: '12', icon: Icons.receipt_long_rounded),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Cart', value: '${cart.itemCount}', icon: Icons.shopping_bag_rounded),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Wishlist', value: '${wish.count}', icon: Icons.favorite_rounded),
                    ]),
                    const SizedBox(height: 20),
                    _Section(title: 'Account', items: [
                      _MenuItem(icon: Icons.person_outline_rounded, label: 'Edit Profile'),
                      _MenuItem(icon: Icons.location_on_outlined, label: 'Shipping Address'),
                      _MenuItem(icon: Icons.credit_card_outlined, label: 'Payment Methods'),
                    ]),
                    const SizedBox(height: 12),
                    _Section(title: 'Shopping', items: [
                      _MenuItem(icon: Icons.receipt_long_outlined, label: 'Order History'),
                      _MenuItem(icon: Icons.local_offer_outlined, label: 'Promotions & Coupons'),
                      _MenuItem(icon: Icons.star_outline_rounded, label: 'Reviews & Ratings'),
                    ]),
                    const SizedBox(height: 12),
                    _Section(title: 'Support', items: [
                      _MenuItem(icon: Icons.help_outline_rounded, label: 'Help Center'),
                      _MenuItem(icon: Icons.settings_outlined, label: 'Settings'),
                      _MenuItem(icon: Icons.logout_rounded, label: 'Log Out', isDestructive: true),
                    ]),
                    const SizedBox(height: 80),
                  ]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.poppins(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 11)),
        ]),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _Section({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(
          title,
          style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          children: items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            return Column(children: [
              item,
              if (i < items.length - 1)
                const Divider(height: 0, thickness: 0.5, color: AppColors.border, indent: 52),
            ]);
          }).toList(),
        ),
      ),
    ]);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  const _MenuItem({required this.icon, required this.label, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.text;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (isDestructive ? AppColors.error : AppColors.accent).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isDestructive ? AppColors.error : AppColors.accent, size: 18),
      ),
      title: Text(label, style: GoogleFonts.poppins(color: color, fontSize: 14)),
      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 18),
      onTap: () {},
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
    );
  }
}
