class AvitoItem {
  final String title;
  final String price;
  final String location;
  final String imageUrl;
  final String timeAgo;
  final String category;
  final bool isFavorite;
  //for the share
  final String link;

  AvitoItem({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.timeAgo,
    required this.category,
    this.isFavorite = false,
    required this.link,
  });
}

// Sample data for the app - English content matching Avito.ru style with real images
final List<AvitoItem> avitoData = [
  AvitoItem(
    title: 'iPhone 14 Pro Max 256GB - Excellent condition',
    price: '₽85,000',
    location: 'Moscow',
    imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=300&fit=crop',
    timeAgo: '2 hours ago',
    category: 'Electronics',
    link: 'https://zareshop.com/products/iphone-14-pro-max-256gb-excellent-condition',
  ),
  AvitoItem(
    title: 'Toyota Camry 2019 - Low mileage, perfect condition',
    price: '₽2,150,000',
    location: 'Saint Petersburg',
    imageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=400&h=300&fit=crop',
    timeAgo: '5 hours ago',
    category: 'Cars',
    link: 'https://zareshop.com/products/toyota-camry-2019-low-mileage-perfect-condition',
  ),
  AvitoItem(
    title: '2-room apartment in center - Renovated',
    price: '₽12,500,000',
    location: 'Moscow',
    imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=400&h=300&fit=crop',
    timeAgo: '1 day ago',
    category: 'Real Estate',
    link: 'https://zareshop.com/products/2-room-apartment-center-renovated',
  ),
  AvitoItem(
    title: 'MacBook Pro M2 512GB - Like new',
    price: '₽125,000',
    location: 'Kazan',
    imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=300&fit=crop',
    timeAgo: '3 hours ago',
    category: 'Electronics',
    link: 'https://zareshop.com/products/macbook-pro-m2-512gb-like-new',
  ),
  AvitoItem(
    title: 'Yamaha R1 1000cc - 2020 model',
    price: '₽850,000',
    location: 'Novosibirsk',
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
    timeAgo: '6 hours ago',
    category: 'Motorcycles',
    link: 'https://zareshop.com/products/yamaha-r1-1000cc-2020-model',
  ),
  AvitoItem(
    title: 'Leather sofa - Brown, excellent condition',
    price: '₽32,000',
    location: 'Yekaterinburg',
    imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400&h=300&fit=crop',
    timeAgo: '4 hours ago',
    category: 'Furniture',
    link: 'https://zareshop.com/products/leather-sofa-brown-excellent-condition',
  ),
  AvitoItem(
    title: 'Samsung 65" 4K Smart TV - 2023 model',
    price: '₽65,000',
    location: 'Moscow',
    imageUrl: 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400&h=300&fit=crop',
    timeAgo: '1 hour ago',
    category: 'Electronics',
    link: 'https://zareshop.com/products/samsung-65-4k-smart-tv-2023-model',
  ),
  AvitoItem(
    title: 'Studio apartment for rent - Near metro',
    price: '₽45,000/month',
    location: 'Saint Petersburg',
    imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400&h=300&fit=crop',
    timeAgo: '2 days ago',
    category: 'Real Estate',
    link: 'https://zareshop.com/products/studio-apartment-rent-near-metro',
  ),
  AvitoItem(
    title: 'Nike Air Jordan 1 Retro - Size 42',
    price: '₽15,000',
    location: 'Moscow',
    imageUrl: 'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=400&h=300&fit=crop',
    timeAgo: '3 hours ago',
    category: 'Clothing',
    link: 'https://zareshop.com/products/nike-air-jordan-1-retro-size-42',
  ),
  AvitoItem(
    title: 'Golden Retriever Puppy - 3 months old',
    price: '₽35,000',
    location: 'Kazan',
    imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?w=400&h=300&fit=crop',
    timeAgo: '1 day ago',
    category: 'Pets',
    link: 'https://zareshop.com/products/golden-retriever-puppy-3-months-old',
  ),
  AvitoItem(
    title: 'Professional Photography Services',
    price: '₽5,000/session',
    location: 'Saint Petersburg',
    imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&h=300&fit=crop',
    timeAgo: '4 hours ago',
    category: 'Services',
    link: 'https://zareshop.com/products/professional-photography-services',
  ),
  AvitoItem(
    title: 'Software Developer - Remote Position',
    price: '₽120,000/month',
    location: 'Moscow',
    imageUrl: 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=400&h=300&fit=crop',
    timeAgo: '5 hours ago',
    category: 'Jobs',
    link: 'https://zareshop.com/products/software-developer-remote-position',
  ),
];

// Categories for filtering
final List<String> categories = [
  'All Categories',
  'Electronics',
  'Cars',
  'Real Estate',
  'Motorcycles',
  'Furniture',
  'Clothing',
  'Services',
  'Jobs',
  'Pets',
];
