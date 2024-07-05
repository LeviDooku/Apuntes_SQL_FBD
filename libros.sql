CREATE TABLE Libros (
    LibroID INT PRIMARY KEY,
    Titulo VARCHAR(255),
    Autor VARCHAR(255),
    Genero VARCHAR(50),
    AnoPublicacion INT,
    Paginas INT
);

INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (1, 'El Quijote', 'Miguel de Cervantes', 'Novela', 1605, 863);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (2, 'Cien Años de Soledad', 'Gabriel García Márquez', 'Realismo Mágico', 1967, 471);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (3, 'Don Juan Tenorio', 'José Zorrilla', 'Drama', 1844, 280);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (4, 'Crimen y Castigo', 'Fiódor Dostoyevski', 'Novela', 1866, 671);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (5, 'La Metamorfosis', 'Franz Kafka', 'Ficción', 1915, 201);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (6, '1984', 'George Orwell', 'Distopía', 1949, 328);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (7, 'Orgullo y Prejuicio', 'Jane Austen', 'Romance', 1813, 279);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (8, 'Moby Dick', 'Herman Melville', 'Aventura', 1851, 585);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (9, 'La Odisea', 'Homero', 'Épica', -800, 543);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (10, 'La Ilíada', 'Homero', 'Épica', -750, 683);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (11, 'Divina Comedia', 'Dante Alighieri', 'Épica', 1320, 704);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (12, 'Los Miserables', 'Victor Hugo', 'Novela', 1862, 1463);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (13, 'El Retrato de Dorian Gray', 'Oscar Wilde', 'Novela', 1890, 254);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (14, 'Alicia en el País de las Maravillas', 'Lewis Carroll', 'Fantasía', 1865, 200);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (15, 'Fausto', 'Johann Wolfgang von Goethe', 'Drama', 1808, 365);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (16, 'El Gran Gatsby', 'F. Scott Fitzgerald', 'Novela', 1925, 180);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (17, 'El Principito', 'Antoine de Saint-Exupéry', 'Fábula', 1943, 96);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (18, 'Madame Bovary', 'Gustave Flaubert', 'Novela', 1857, 328);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (19, 'Ulises', 'James Joyce', 'Novela', 1922, 730);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (20, 'Drácula', 'Bram Stoker', 'Terror', 1897, 418);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (21, 'Frankenstein', 'Mary Shelley', 'Terror', 1818, 280);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (22, 'Hamlet', 'William Shakespeare', 'Tragedia', 1600, 210);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (23, 'Macbeth', 'William Shakespeare', 'Tragedia', 1606, 130);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (24, 'La Tempestad', 'William Shakespeare', 'Comedia', 1611, 120);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (25, 'Romeo y Julieta', 'William Shakespeare', 'Tragedia', 1597, 128);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (26, 'El Rey Lear', 'William Shakespeare', 'Tragedia', 1606, 160);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (27, 'En busca del tiempo perdido', 'Marcel Proust', 'Novela', 1913, 4215);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (28, 'La montaña mágica', 'Thomas Mann', 'Novela', 1924, 728);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (29, 'El sonido y la furia', 'William Faulkner', 'Novela', 1929, 378);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (30, 'La peste', 'Albert Camus', 'Novela', 1947, 308);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (31, 'La náusea', 'Jean-Paul Sartre', 'Novela', 1938, 253);
INSERT INTO Libros (LibroID, Titulo, Autor, Genero,  AnoPublicacion, Paginas) VALUES (50, 'Origen', 'Dan Brown', 'Thriller', 2017, 456);
