import Foundation

// MARK: - Meat Options
let standardMeats = [
    "Asada", "Al Pastor", "Pollo", "Carnitas",
    "Chorizo", "Adobada", "Barbacoa", "Lengua",
    "Cabeza", "Chicharrón", "Chile Verde"
]
let vegOptions   = ["Grilled Veggie", "Cauliflower Asada", "Bean & Cheese"]
let seafoodOpts  = ["Fried Fish", "Grilled Fish", "Shrimp"]

// MARK: - Full Menu
let allMenuItems: [MenuItem] = [

    // ─── TACOS ───────────────────────────────────────────────────────────────
    MenuItem(name: "Street Taco",
             description: "Two soft corn tortillas, your choice of meat, onion, cilantro & house salsa",
             price: 4.75, category: .tacos,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: true, cardColorHex: "E8C99A"),

    MenuItem(name: "Aggie Taco",
             description: "Fried fish on a signature purple tortilla with cabbage, pico de gallo & chipotle crema",
             price: 5.50, category: .tacos,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: false, isPopular: true, cardColorHex: "C8A2C8"),

    MenuItem(name: "Veggie Taco",
             description: "Grilled seasonal vegetables or cauliflower asada on corn tortillas with fresh salsa",
             price: 4.25, category: .tacos,
             hasMeatChoice: true, meatOptions: vegOptions,
             isVegetarian: true, isPopular: false, cardColorHex: "A8D9A0"),

    MenuItem(name: "Crispy Taco",
             description: "Hard shell taco with choice of meat, shredded lettuce, cheese & guacamole",
             price: 4.50, category: .tacos,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: false, cardColorHex: "F5D6A8"),

    MenuItem(name: "Quesabirria Taco",
             description: "Slow-braised beef birria with melted cheese on a dipped & fried tortilla, served with consommé",
             price: 5.75, category: .tacos,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: false, isPopular: true, cardColorHex: "E8B490"),

    MenuItem(name: "Seafood Taco",
             description: "Your choice of fried fish, grilled fish or shrimp with cabbage slaw & chipotle sauce",
             price: 5.25, category: .tacos,
             hasMeatChoice: true, meatOptions: seafoodOpts,
             isVegetarian: false, isPopular: false, cardColorHex: "A8CEE8"),

    // ─── BURRITOS ─────────────────────────────────────────────────────────────
    MenuItem(name: "Regular Burrito",
             description: "Choice of meat, beans & salsa wrapped in a warm flour tortilla",
             price: 9.99, category: .burritos,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: false, cardColorHex: "F5D6A8"),

    MenuItem(name: "Super Burrito",
             description: "Choice of meat, rice, beans, sour cream, guacamole, pico de gallo & cheese",
             price: 11.99, category: .burritos,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: true, cardColorHex: "E8C090"),

    MenuItem(name: "Veggie Burrito",
             description: "Grilled vegetables or cauliflower asada, rice, beans, sour cream, guacamole & cheese",
             price: 10.99, category: .burritos,
             hasMeatChoice: true, meatOptions: vegOptions,
             isVegetarian: true, isPopular: false, cardColorHex: "A8D9A0"),

    MenuItem(name: "Giant 3-lb Burrito",
             description: "The legendary 3-pound beast — feeds 2–3 people. Available with any meat",
             price: 20.99, category: .burritos,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: true, cardColorHex: "D4A86A"),

    // ─── QUESADILLAS ──────────────────────────────────────────────────────────
    MenuItem(name: "Cheese Quesadilla",
             description: "Flour tortilla filled with melted cheese, served with salsa & sour cream",
             price: 7.99, category: .quesadillas,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: true, isPopular: false, cardColorHex: "F5E6A8"),

    MenuItem(name: "Super Quesadilla",
             description: "Large flour tortilla filled with cheese & choice of meat, rice, beans & guacamole",
             price: 11.99, category: .quesadillas,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: true, cardColorHex: "F5D6A8"),

    // ─── NACHOS ───────────────────────────────────────────────────────────────
    MenuItem(name: "Guad's Nachos",
             description: "Crispy chips loaded with beans, cheese, jalapeños, sour cream & pico de gallo",
             price: 12.99, category: .nachos,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: true, cardColorHex: "F5C860"),

    MenuItem(name: "Super Nachos",
             description: "Everything on regular nachos plus guacamole, extra cheese & extra meat",
             price: 15.99, category: .nachos,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: false, cardColorHex: "E8B840"),

    // ─── PLATES ───────────────────────────────────────────────────────────────
    MenuItem(name: "Combo Plate",
             description: "Two items of your choice (taco, tamale, enchilada or tostada) with rice & beans",
             price: 13.99, category: .plates,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: false, cardColorHex: "E8D5B7"),

    MenuItem(name: "Grilled Fish Plate",
             description: "Grilled mahi-mahi with seasoned rice, beans, lettuce, pico & chipotle crema",
             price: 15.99, category: .plates,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: false, isPopular: false, cardColorHex: "A8CEE8"),

    MenuItem(name: "Shrimp Plate",
             description: "Sautéed or fried shrimp with rice, beans, lettuce, pico & your choice of sauce",
             price: 16.99, category: .plates,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: false, isPopular: false, cardColorHex: "F0C8A0"),

    MenuItem(name: "Taco Salad",
             description: "Crispy tortilla bowl with lettuce, meat, beans, cheese, sour cream & guacamole",
             price: 11.99, category: .plates,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: false, cardColorHex: "C8E8A0"),

    // ─── BREAKFAST ────────────────────────────────────────────────────────────
    MenuItem(name: "Breakfast Burrito",
             description: "Scrambled eggs, cheese, potato & choice of meat in a warm flour tortilla",
             price: 9.99, category: .breakfast,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: true, cardColorHex: "F5E0A0"),

    MenuItem(name: "Huevos Rancheros",
             description: "Two eggs over easy on corn tortillas with ranchero sauce, rice & beans",
             price: 10.99, category: .breakfast,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: true, isPopular: false, cardColorHex: "F5D6A8"),

    MenuItem(name: "Breakfast Quesadilla",
             description: "Scrambled eggs, cheese & salsa in a golden grilled flour tortilla",
             price: 9.99, category: .breakfast,
             hasMeatChoice: true, meatOptions: standardMeats,
             isVegetarian: false, isPopular: false, cardColorHex: "F5E8A8"),

    MenuItem(name: "Quesabirria Plate",
             description: "Three quesabirria tacos with consommé, onion, cilantro & lime",
             price: 14.99, category: .breakfast,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: false, isPopular: true, cardColorHex: "E8B490"),

    // ─── DRINKS ───────────────────────────────────────────────────────────────
    MenuItem(name: "Guads Blonde Ale",
             description: "Our signature house-brewed craft ale — light, crisp & refreshing",
             price: 7.00, category: .drinks,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: true, isPopular: true, cardColorHex: "F5D080"),

    MenuItem(name: "Draft Beer",
             description: "Rotating local & craft selections on tap — ask your server for today's list",
             price: 6.00, category: .drinks,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: true, isPopular: false, cardColorHex: "D4B870"),

    MenuItem(name: "Mexican Soda",
             description: "Jarritos, Mexican Coke or Topo Chico — ask for current flavors",
             price: 3.00, category: .drinks,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: true, isPopular: false, cardColorHex: "E8A0A0"),

    MenuItem(name: "Agua Fresca",
             description: "Freshly made daily — hibiscus, watermelon, tamarind & more",
             price: 3.50, category: .drinks,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: true, isPopular: false, cardColorHex: "F0A8C0"),

    MenuItem(name: "Horchata",
             description: "Classic homemade rice milk with cinnamon & vanilla",
             price: 3.50, category: .drinks,
             hasMeatChoice: false, meatOptions: [],
             isVegetarian: true, isPopular: false, cardColorHex: "E8D8C0"),
]
