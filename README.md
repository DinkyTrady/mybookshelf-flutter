# Laporan Pembuatan Aplikasi Flutter Sederhana

## I. Halaman Judul
*   **Judul Laporan:** Laporan Pembuatan Aplikasi Flutter Sederhana
*   **Nama Aplikasi:** My Bookshelf
*   **Logo Aplikasi:** (Opsional, bisa disertakan di sini atau di bagian lain)
*   **Nama Pembuat:** Randy Dinky Saputra
*   **NIM:** [Nomor Induk Mahasiswa Anda]
*   **Kelas:** [Kelas Anda]
*   **Tanggal Penyerahan:** [Tanggal Penyerahan Laporan, sesuai deadline]

## II. Daftar Isi
*   (Otomatis dibuat setelah laporan selesai)

## III. Pendahuluan
*   **A. Latar Belakang:**
    Dalam era digital yang terus berkembang pesat, aplikasi berbasis web telah menjadi bagian integral dari berbagai sektor, memfasilitasi interaksi pengguna dan pengelolaan data melalui browser. Flutter, sebagai framework pengembangan UI yang dikembangkan oleh Google, menawarkan kemampuan unik untuk membangun aplikasi multi-platform (termasuk web) dengan codebase tunggal, menjadikannya pilihan yang efisien dan powerful untuk pengembangan aplikasi web modern yang kaya akan antarmuka pengguna.

    Laporan ini disusun sebagai bagian dari pemenuhan tugas [Nama Mata Kuliah, jika ada, atau "proyek pengembangan aplikasi"] yang bertujuan untuk mengimplementasikan sebuah aplikasi Flutter berbasis web sederhana. Aplikasi ini dirancang untuk mendemonstrasikan fitur-fitur dasar seperti otentikasi pengguna melalui halaman login, tampilan data dalam bentuk daftar, serta detail informasi dari setiap item data. Selain itu, pengembangan aplikasi ini juga menekankan pada penerapan prinsip-prinsip Object-Oriented Programming (OOP) seperti encapsulation, inheritance, dan polymorphism dalam struktur data modelnya, guna memastikan kode yang terstruktur, mudah dikelola, dan scalable.

*   **B. Tujuan Laporan:**
    Tujuan dari penyusunan laporan ini adalah sebagai berikut:
    1. Mendokumentasikan proses perancangan dan implementasi aplikasi Flutter berbasis web sederhana sesuai dengan spesifikasi yang telah ditentukan.
    2. Menjelaskan secara rinci fitur-fitur utama aplikasi, meliputi Splash Screen, Halaman Login, Halaman Home, dan Halaman Detail.
    3. Menganalisis dan memaparkan penerapan konsep Object-Oriented Programming (OOP) – encapsulation, inheritance, dan polymorphism – dalam struktur data model aplikasi.
    4. Menyediakan panduan teknis dan screenshot sebagai bukti fungsionalitas aplikasi yang telah dikembangkan.

## IV. Perancangan Aplikasi

*   **A. Arsitektur Aplikasi:**
    Aplikasi ini dirancang dengan mengadopsi arsitektur modular yang terstruktur, memisahkan tanggung jawab setiap komponen untuk meningkatkan keterbacaan, pemeliharaan, dan skalabilitas kode. Struktur direktori utama (`lib/`) dibagi menjadi beberapa lapisan fungsional:
    *   `lib/main.dart`: Berfungsi sebagai titik masuk utama aplikasi, menginisialisasi aplikasi Flutter dan mengonfigurasi tema global.
    *   `lib/models/`: Berisi definisi kelas-kelas data (data models) yang merepresentasikan entitas bisnis dalam aplikasi, seperti `Book`, `Comic`, `LibraryItem` (sebagai kelas dasar abstrak), dan `User`. Ini adalah inti dari penerapan konsep OOP.
    *   `lib/presentation/`: Mengandung semua komponen antarmuka pengguna (UI) dan
    logika presentasi terkait. Direktori ini lebih lanjut dibagi berdasarkan fitur 
    (`auth`, `bookshelf`, `home`, `splash`) untuk mengelompokkan layar (screens), widget, dan `ViewModel` yang relevan.
    *   `lib/services/`: Menyediakan lapisan logika bisnis dan abstraksi untuk interaksi data. Contohnya, `AuthService` menangani otentikasi pengguna, sementara `BookshelfService` mengelola operasi CRUD (Create, Read, Update, Delete) untuk item perpustakaan.
    Pembagian arsitektur ini secara efektif menerapkan prinsip Separation of Concerns, memungkinkan pengembangan yang efisien dan mempermudah pengujian serta pembaruan di masa mendatang.

*   **B. Desain UI/UX (User Interface/User Experience):**
    Desain antarmuka pengguna (UI) aplikasi ini mengedepankan estetika modern, bersih, dan intuitif untuk memastikan pengalaman pengguna (UX) yang optimal. Penggunaan Material Design dari Flutter diterapkan secara konsisten di seluruh aplikasi.

    *   **1. Splash Screen:**
        Splash screen, yang diimplementasikan dalam `lib/presentation/splash/splash_screen.dart`, berfungsi sebagai layar pembuka aplikasi. Desainnya mencakup tampilan logo aplikasi (`assets/images/bookshelf-icon.webp`), nama aplikasi ("My Bookshelf"), dan identitas pembuat ("Developed by Randy Dinky Saputra"). Tujuan utamanya adalah untuk memberikan kesan pertama yang menarik dan informatif kepada pengguna, sekaligus menutupi proses inisialisasi aplikasi. Splash screen ini akan ditampilkan selama 3 detik dengan efek animasi transisi (fade-in dan scale-up) sebelum secara otomatis mengarahkan pengguna ke halaman login.

    *   **2. Halaman Login:**
        Halaman login (`lib/presentation/auth/login_screen.dart`) dirancang dengan fokus pada kemudahan penggunaan dan keamanan dasar. Elemen UI yang tersedia meliputi:
        *   Input `Username`: Menggunakan widget `TextField` dengan ikon `Icons.person_outline` sebagai indikator visual.
        *   Input `Password`: Menggunakan widget `TextField` dengan ikon `Icons.lock_outline` dan dilengkapi dengan tombol `IconButton` (`visibility_off/visibility`) untuk mengaktifkan/menonaktifkan tampilan teks password, meningkatkan kenyamanan pengguna.
        *   Tombol `Login`: Didesain dengan efek gradien yang menarik, memberikan umpan balik visual saat ditekan.
        *   Tombol `TextButton`: Menyediakan opsi navigasi ke halaman registrasi bagi pengguna yang belum memiliki akun.
        Validasi sederhana diterapkan pada input (misalnya, memastikan field tidak kosong). Jika kredensial valid, pengguna akan dinavigasi ke `HomeScreen`.

    *   **3. Halaman Home:**
        Halaman Home (`lib/presentation/home/home_screen.dart`) adalah pusat interaksi utama pengguna setelah otentikasi. Halaman ini menampilkan daftar item perpustakaan (buku dan komik) secara efisien menggunakan `ListView.builder`. Setiap item direpresentasikan oleh widget `LibraryItemCard` yang didesain secara rapi, menampilkan informasi kunci seperti judul, penulis, tipe (untuk komik), genre (untuk komik), status baca, dan indikator progres baca (progress bar) jika item sedang dibaca. Fungsionalitas pencarian memungkinkan pengguna mencari item berdasarkan judul atau penulis. Selain itu, terdapat opsi filter berdasarkan tipe item (semua, buku saja, atau komik saja) dan pengurutan (berdasarkan judul, penulis, atau tanggal penambahan) untuk memudahkan navigasi dan pengelolaan koleksi.

    *   **4. Halaman Detail:**
        Halaman Detail (`lib/presentation/bookshelf/book_details_screen.dart`) menyediakan informasi yang lebih komprehensif mengenai item perpustakaan yang dipilih dari halaman Home. Tampilan ini mencakup gambar sampul item, judul, nama penulis, ringkasan, serta detail spesifik lainnya seperti jumlah halaman/bab, progres baca, tipe (untuk komik), genre (untuk komik), dan status. Halaman ini juga dilengkapi dengan tombol aksi untuk mengedit detail item atau menghapus item dari koleksi, memastikan pengguna memiliki kontrol penuh atas data mereka.

*   **C. Perancangan Data Model (Konsep OOP):**
    Penerapan konsep Object-Oriented Programming (OOP) merupakan fondasi penting dalam perancangan model data aplikasi ini, memastikan struktur kode yang logis, mudah dipahami, dan dapat diperluas.

    *   **1. Encapsulation:**
        Enkapsulasi diimplementasikan dengan mendeklarasikan properti-properti internal kelas sebagai `private` menggunakan konvensi underscore (`_`) di awal nama properti (misalnya, `_id`, `_title`, `_author` di `LibraryItem`, serta properti spesifik di `Book` dan `Comic`). Akses ke properti-properti ini hanya dapat dilakukan melalui metode `getter` publik yang sesuai. Pendekatan ini melindungi integritas data dengan mencegah modifikasi langsung dari luar kelas dan memastikan bahwa perubahan data hanya terjadi melalui antarmuka yang terkontrol.

        ```dart
        abstract class LibraryItem {
          final String _id;
          String _title; // Can be modified internally, but accessed via getter
          final String _author;
          // ... properti lainnya

          // Getters
          String get id => _id;
          String get title => _title;
          String get author => _author;
          // ... getters lainnya
        }
        ```
        Dengan demikian, properti internal objek terlindungi dari modifikasi langsung dari luar kelas, memastikan integritas data.

    *   **2. Inheritance:**
        Konsep pewarisan (inheritance) dimanfaatkan untuk membangun hierarki kelas yang efisien. Kelas `Book` dan `Comic` didefinisikan sebagai subclass yang mewarisi dari kelas dasar abstrak `LibraryItem`. Ini memungkinkan `Book` dan `Comic` untuk secara otomatis mendapatkan properti dan perilaku umum yang didefinisikan di `LibraryItem` (seperti `id`, `title`, `author`, `summary`, `coverImageUrl`), sambil pada saat yang sama menambahkan properti dan metode spesifik yang hanya relevan untuk jenis item tersebut (misalnya, `pageCount` untuk `Book`, atau `type` dan `genre` untuk `Comic`). Pewarisan ini mempromosikan penggunaan kembali kode dan menciptakan struktur data yang logis.

        ```dart
        // lib/models/library_item.dart
        abstract class LibraryItem {
          // ... properti dan metode umum
        }

        // lib/models/book.dart
        class Book extends LibraryItem {
          // ... properti dan metode spesifik Book
        }

        // lib/models/comic.dart
        class Comic extends LibraryItem {
          // ... properti dan metode spesifik Comic
        }
        ```

    *   **3. Polymorphism:**
        Polimorfisme diimplementasikan melalui penggunaan metode abstrak di kelas `LibraryItem` yang kemudian di-override (diimplementasikan ulang) secara spesifik oleh subclass `Book` dan `Comic`. Contohnya adalah metode `getDetails()`, `getProgressText()`, `getStatusText()`, dan `copyWith()`. Ini memungkinkan objek `Book` dan `Comic` untuk diperlakukan secara seragam sebagai `LibraryItem` dalam konteks umum (misalnya, dalam sebuah daftar `List<LibraryItem>`), namun ketika metode polimorfik dipanggil, implementasi yang sesuai dengan tipe objek sebenarnya akan dieksekusi. Hal ini meningkatkan fleksibilitas dan ekstensibilitas kode, memungkinkan penambahan jenis item perpustakaan baru di masa depan dengan dampak minimal pada kode yang sudah ada.

        ```dart
        // lib/models/library_item.dart
        abstract class LibraryItem {
          // ...
          String getDetails(); // Metode abstrak
          LibraryItem copyWith({ /* ... */ }); // Metode abstrak
          String getProgressText();
          String getStatusText();
        }

        // lib/models/book.dart
        class Book extends LibraryItem {
          // ...
          @override
          String getDetails() {
            return 'Book: $title by $author, $_pageCount pages, Progress: ${(progressPercentage * 100).toStringAsFixed(1)}%';
          }

          @override
          Book copyWith({ /* ... */ }) { /* ... */ }
          @override
          String getProgressText() { /* ... Book specific progress ... */ }
        }

        // lib/models/comic.dart
        class Comic extends LibraryItem {
          // ...
          @override
          String getDetails() {
            return 'Komik: $title ($type) by $author, $genre, $_chapters chapters, $status';
          }

          @override
          Comic copyWith({ /* ... */ }) { /* ... */ }) { /* ... */ }
          @override
          String getProgressText() { /* ... Comic specific progress ... */ }
          @override
          String getStatusText() { /* ... Comic specific status ... */ }
        }
        ```

## V. Implementasi Aplikasi

*   **A. Lingkungan Pengembangan:**
    *   **Flutter SDK Version:** `3.9.0` (sesuai `pubspec.yaml`)
    *   **Dart SDK Version:** `^3.9.0` (sesuai `pubspec.yaml`)
    *   **IDE:** Visual Studio Code
    *   **Dependencies:** `cupertino_icons`, `google_fonts` (sesuai `pubspec.yaml`)

*   **B. Implementasi Fitur Utama:**

    *   **1. Splash Screen:**
        Implementasi splash screen berada di `lib/presentation/splash/splash_screen.dart`. Menggunakan `AnimationController` dan `Tween` untuk efek skala dan fade-in pada logo dan teks. `Timer` digunakan untuk menunda navigasi ke `LoginScreen` setelah 3 detik.

        ```dart
        // lib/presentation/splash/splash_screen.dart
        class _SplashScreenState extends State<SplashScreen>
            with SingleTickerProviderStateMixin {
          late AnimationController _controller;
          late Animation<double> _scaleAnimation;
          late Animation<double> _fadeAnimation;

          @override
          void initState() {
            super.initState();
            _controller = AnimationController(
              duration: const Duration(seconds: 2),
              vsync: this,
            );
            _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
            );
            _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeIn),
            );
            _controller.forward();
            Timer(
              const Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen(),
                ),
              ),
            );
          }
          // ... build method
        }
        ```

    *   **2. Halaman Login:**
        Halaman login diimplementasikan di `lib/presentation/auth/login_screen.dart`. Menggunakan `TextEditingController` untuk input username dan password. Logika otentikasi ditangani oleh `AuthService`. Navigasi ke `HomeScreen` dilakukan menggunakan `Navigator.of(context).pushReplacement` setelah login berhasil. Animasi fade dan slide juga diterapkan pada elemen UI.

        ```dart
        // lib/presentation/auth/login_screen.dart
        class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
          final _usernameController = TextEditingController();
          final _passwordController = TextEditingController();
          final _authService = AuthService();
          // ... animations and other state

          void _login() async {
            setState(() { _isLoading = true; });
            final user = await _authService.login(
              _usernameController.text,
              _passwordController.text,
            );
            if (mounted) {
              setState(() { _isLoading = false; });
              if (user != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid username or password')),
                );
              }
            }
          }
          // ... build method
        }
        ```

    *   **3. Halaman Home:**
        Halaman Home (`lib/presentation/home/home_screen.dart`) menggunakan `HomeViewModel` (`lib/presentation/home/home_view_model.dart`) untuk mengelola state dan logika bisnis. Daftar item ditampilkan menggunakan `ListView` dan `LibraryItemCard`. Fungsionalitas pencarian diimplementasikan dengan `TextEditingController` dan `_viewModel.updateSearchQuery()`. Filter dan sort diatur melalui `PopupMenuButton` yang memanggil metode `_viewModel.updateItemTypeFilter()` dan `_viewModel.updateSortOption()`. Penambahan item baru dilakukan melalui dialog yang memanggil `_showAddItemDialog()`.

        ```dart
        // lib/presentation/home/home_screen.dart
        class _HomeScreenState extends State<HomeScreen> {
          final HomeViewModel _viewModel = HomeViewModel();
          final TextEditingController _searchController = TextEditingController();

          // ... initState, dispose, _onSearchChanged, _showAddItemDialog, _showItemTypeDialog, _showSortDialog

          @override
          Widget build(BuildContext context) {
            return Scaffold(
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      _buildAppBar(theme),
                      _buildSearchAndFilters(theme),
                      _buildLibraryItemsList(), // This uses AnimatedBuilder with _viewModel
                    ],
                  ),
                ),
              ),
            );
          }
          // ... _buildAppBar, _navigateToLogin, _buildSearchAndFilters, _buildLibraryItemsList, _buildSectionHeader
        }
        ```

    *   **4. Halaman Detail:**
        Halaman Detail (`lib/presentation/bookshelf/book_details_screen.dart`) menerima objek `LibraryItem` sebagai parameter. Ini menampilkan detail item menggunakan `Card` dan `Image.network` untuk sampul. Tombol edit memicu `_showEditFormDialog()` yang menampilkan `LibraryItemForm` untuk mengedit item, dan tombol delete memicu `_deleteItem()` setelah konfirmasi.

        ```dart
        // lib/presentation/bookshelf/book_details_screen.dart
        class _LibraryItemDetailsScreenState extends State<LibraryItemDetailsScreen> {
          final BookshelfService _bookshelfService = BookshelfService();

          void _deleteItem() async {
            Navigator.of(context).pop(); // Pop the details screen before deleting
            await _bookshelfService.deleteItem(widget.item.id);
          }

          Future<void> _showEditFormDialog() async {
            final formKey = GlobalKey<LibraryItemFormState>();
            return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Edit ${widget.item is Comic ? 'Komik' : 'Book'}'),
                  content: Container(
                    child: SingleChildScrollView(
                      child: LibraryItemForm(key: formKey, item: widget.item, isKomik: widget.item is Comic),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        final newItem = formKey.currentState?.saveAndGetItem();
                        if (newItem != null) {
                          await _bookshelfService.updateItem(newItem);
                          Navigator.of(context).pop(); // Pop the dialog
                          Navigator.of(context).pop(); // Pop the details screen to force a refresh
                        }
                      },
                    ),
                  ],
                );
              },
            );
          }
          // ... build method
        }
        ```

*   **C. Penerapan Konsep OOP dalam Kode:**

    *   **Encapsulation:**
        Properti seperti `_id`, `_title`, `_author` di kelas `LibraryItem` dan properti spesifik di `Book` (`_pageCount`, `_currentPage`) serta `Comic` (`_type`, `_genre`, `_chapters`, `_currentChapter`, `_status`) dideklarasikan sebagai `final` atau `private` dan hanya dapat diakses melalui `getter` publik.

        ```dart
        // lib/models/library_item.dart
        abstract class LibraryItem {
          final String _id;
          String _title; // Can be modified internally, but accessed via getter
          final String _author;
          // ...
          String get id => _id;
          String get title => _title;
          String get author => _author;
          // ...
        }
        ```

    *   **Inheritance:**
        Kelas `Book` dan `Comic` memperluas kelas abstrak `LibraryItem`, mewarisi properti dan metode dasar serta menambahkan properti dan logika unik mereka.

        ```dart
        // lib/models/book.dart
        class Book extends LibraryItem {
          final int _pageCount;
          final int _currentPage;

          Book({
            required String id,
            // ... common properties
            required int pageCount,
            int currentPage = 0,
            // ...
          })  : _pageCount = pageCount,
                _currentPage = currentPage,
                super( /* ... common properties */ );
          // ...
        }

        // lib/models/comic.dart
        class Comic extends LibraryItem {
          final String _type;
          final String _genre;
          // ...
          Comic({
            required String id,
            // ... common properties
            required String type,
            required String genre,
            // ...
          })  : _type = type,
                _genre = genre,
                super( /* ... common properties */ );
          // ...
        }
        ```

    *   **Polymorphism:**
        Metode `getDetails()`, `getProgressText()`, `getStatusText()`, dan `copyWith()` didefinisikan sebagai abstrak di `LibraryItem` dan diimplementasikan secara spesifik di `Book` dan `Comic`. Ini memungkinkan penanganan objek `Book` dan `Comic` secara seragam sebagai `LibraryItem` sambil tetap mempertahankan perilaku unik mereka.

        ```dart
        // lib/models/library_item.dart
        abstract class LibraryItem {
          // ...
          String getDetails();
          LibraryItem copyWith({ /* ... */ });
          String getProgressText();
          String getStatusText();
        }

        // lib/models/book.dart
        class Book extends LibraryItem {
          // ...
          @override
          String getDetails() { /* ... Book specific details ... */ }
          @override
          Book copyWith({ /* ... Book specific copy logic ... */ }) { /* ... */ }
          @override
          String getProgressText() { /* ... Book specific progress ... */ }
        }

        // lib/models/comic.dart
        class Comic extends LibraryItem {
          // ...
          @override
          String getDetails() { /* ... Comic specific details ... */ }
          @override
          Comic copyWith({ /* ... Comic specific copy logic ... */ }) { /* ... */ }
          @override
          String getProgressText() { /* ... Comic specific progress ... */ }
          @override
          String getStatusText() { /* ... Comic specific status ... */ }
        }
        ```

## VI. Pengujian Aplikasi

Pengujian aplikasi merupakan fase krusial dalam siklus pengembangan perangkat lunak untuk memastikan bahwa aplikasi berfungsi sesuai dengan spesifikasi yang diharapkan dan bebas dari cacat. Bagian ini mendokumentasikan skenario pengujian yang telah dilakukan dan hasil yang diperoleh.

*   **A. Skenario Pengujian:**
    Pengujian fungsionalitas aplikasi dilakukan dengan serangkaian skenario untuk memverifikasi setiap fitur utama. Skenario-skenario ini dirancang untuk mencakup alur kerja pengguna yang umum serta kondisi batas.
    1.  **Uji Splash Screen:** Memastikan splash screen tampil dengan benar (logo, nama aplikasi, nama pembuat) dan secara otomatis menavigasi ke halaman login setelah durasi yang ditentukan (3 detik).
    2.  **Uji Login Berhasil:** Memasukkan kredensial pengguna yang valid (username: `admin`, password: `admin`) dan memverifikasi bahwa aplikasi berhasil menavigasi ke `HomeScreen`.
    3.  **Uji Login Gagal:** Memasukkan kredensial yang tidak valid (username/password salah atau kosong) dan memverifikasi bahwa aplikasi menampilkan pesan kesalahan yang sesuai (misalnya, "Invalid username or password") tanpa menavigasi ke `HomeScreen`.
    4.  **Uji Registrasi Akun Baru:** Mendaftar akun baru dengan username dan password yang belum terdaftar, serta memverifikasi bahwa proses registrasi berhasil dan pengguna diarahkan kembali ke halaman login.
    5.  **Uji Registrasi Gagal:** Mencoba mendaftar dengan username yang sudah ada atau dengan password yang tidak cocok dengan konfirmasi password, dan memverifikasi bahwa aplikasi menampilkan pesan kesalahan yang relevan.
    6.  **Uji Penambahan Item (Buku):** Menambahkan item baru berjenis buku melalui form penambahan, mengisi semua detail yang diperlukan, dan memverifikasi bahwa buku tersebut muncul dalam daftar di `HomeScreen`.
    7.  **Uji Penambahan Item (Komik):** Menambahkan item baru berjenis komik melalui form penambahan, mengisi semua detail yang diperlukan, dan memverifikasi bahwa komik tersebut muncul dalam daftar di `HomeScreen`.
    8.  **Uji Tampilan Daftar Item:** Memverifikasi bahwa semua item (buku dan komik) yang telah ditambahkan ditampilkan dengan benar di `HomeScreen`, termasuk judul, penulis, tipe (untuk komik), genre (untuk komik), dan status baca.
    9.  **Uji Pencarian Item:** Menggunakan fitur pencarian untuk mencari item berdasarkan judul atau nama penulis, dan memverifikasi bahwa hanya item yang relevan yang ditampilkan dalam daftar.
    10. **Uji Filter Tipe Item:** Menerapkan filter untuk hanya menampilkan buku (`Books Only`) atau hanya komik (`Komiks Only`), dan memverifikasi bahwa daftar item diperbarui sesuai dengan filter yang dipilih.
    11. **Uji Pengurutan Item:** Mengubah opsi pengurutan (berdasarkan judul, penulis, atau tanggal penambahan) dan memverifikasi bahwa daftar item di `HomeScreen` diurutkan dengan benar sesuai kriteria yang dipilih.
    12. **Uji Navigasi ke Halaman Detail:** Mengklik salah satu item dalam daftar di `HomeScreen` dan memverifikasi bahwa aplikasi berhasil menavigasi ke halaman detail yang menampilkan informasi lengkap dari item tersebut.
    13. **Uji Edit Item:** Mengakses halaman detail atau opsi edit dari `LibraryItemCard`, memodifikasi beberapa detail item, menyimpan perubahan, dan memverifikasi bahwa perubahan tersebut tercermin di halaman detail dan `HomeScreen`.
    14. **Uji Hapus Item:** Menghapus item dari `HomeScreen` (melalui `LibraryItemCard`) atau dari halaman detail (setelah konfirmasi), dan memverifikasi bahwa item tersebut berhasil dihapus dari daftar.
    15. **Uji Toggle Status Selesai:** Mengubah status `isFinished` item (misalnya, dari "Reading" menjadi "Finished" atau sebaliknya) dan memverifikasi bahwa item berpindah antara bagian "Currently Reading" dan "Completed" di `HomeScreen`.
    16. **Uji Logout:** Mengklik tombol logout dan memverifikasi bahwa pengguna berhasil keluar dari sesi dan diarahkan kembali ke `LoginScreen`.

*   **B. Hasil Pengujian (dengan Screenshot):**
    Setiap skenario pengujian yang berhasil divalidasi akan didukung dengan screenshot yang relevan. Screenshot ini berfungsi sebagai bukti visual dari fungsionalitas aplikasi yang telah diimplementasikan.
    *   [Sertakan screenshot Splash Screen yang menampilkan logo dan nama pembuat]
    *   [Sertakan screenshot Halaman Login (termasuk contoh saat validasi gagal)]
    *   [Sertakan screenshot Halaman Registrasi]
    *   [Sertakan screenshot Halaman Home (menampilkan daftar data, termasuk bagian "Currently Reading" dan "Completed")]
    *   [Sertakan screenshot Halaman Home (menampilkan hasil pencarian atau filter yang diterapkan)]
    *   [Sertakan screenshot Halaman Detail (menampilkan informasi lengkap item yang dipilih)]
    *   [Sertakan screenshot Form Penambahan/Edit Item (saat mengisi data atau setelah perubahan)]

## VII. Kesimpulan

*   **A. Ringkasan:**
    Aplikasi Flutter sederhana "My Bookshelf" telah berhasil dikembangkan untuk mengelola koleksi buku dan komik pribadi. Aplikasi ini mencakup fitur otentikasi pengguna (login dan registrasi), tampilan daftar item dengan kemampuan pencarian, filter, dan pengurutan, serta halaman detail untuk setiap item dengan opsi edit dan hapus. Konsep Object-Oriented Programming seperti Encapsulation, Inheritance, dan Polymorphism telah diterapkan secara efektif dalam perancangan model data dan logika bisnis, menghasilkan kode yang terstruktur dan mudah dikelola.

*   **B. Saran dan Pengembangan:**
    Untuk pengembangan lebih lanjut, beberapa fitur yang dapat ditambahkan meliputi:
    *   **Persistensi Data:** Menggunakan database lokal (misalnya Hive atau SQLite) atau cloud (misalnya Firebase Firestore) untuk menyimpan data secara permanen, bukan hanya dalam memori.
    *   **Manajemen State Lanjutan:** Mengimplementasikan solusi manajemen state yang lebih canggih (misalnya Provider, Riverpod, BLoC) untuk skala aplikasi yang lebih besar.
    *   **Validasi Form yang Lebih Robust:** Menambahkan validasi yang lebih komprehensif pada semua form input.
    *   **Fitur Notifikasi:** Memberikan notifikasi untuk pengingat membaca atau pembaruan item.
    *   **Integrasi API:** Mengintegrasikan dengan API eksternal (misalnya Google Books API) untuk mengambil detail buku secara otomatis.
    *   **Desain Responsif Lanjutan:** Mengoptimalkan tata letak untuk berbagai ukuran layar dan orientasi perangkat.

## VIII. Lampiran

*   **A. Link Repositori GitHub:**
    [Sertakan URL lengkap ke repositori GitHub Anda di sini]

*   **B. Kode Lengkap (Opsional):**
    Jika diminta, Anda bisa menyertakan kode lengkap dari file-file utama di sini, atau cukup mengarahkan ke repositori GitHub yang telah disediakan.
