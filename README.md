Contrato de Subasta - Sepolia

Este es mi contrato de una subasta que hice como trabajo final del curso.

---

## ¿Qué hace este contrato?

Permite hacer una subasta donde la gente puede hacer ofertas en ETH por un artículo. Cada nueva oferta tiene que ser al menos un 5% más alta que la anterior.

Si alguien hace una oferta cuando quedan menos de 10 minutos, el tiempo de la subasta se extiende 10 minutos más para que otros puedan seguir participando.

---

## Funciones principales

- **ofertar()**: Haces una oferta enviando ETH.  
- **retirarParcial(index)**: Puedes sacar parte del dinero que ofertaste antes si cambiaste tu oferta.  
- **finalizarSubasta()**: El dueño cierra la subasta cuando se acaba el tiempo.  
- **mostrarGanador()**: Te dice quién ganó y cuánto pagó.  
- **mostrarOfertas()**: Muestra todos los que hicieron ofertas y cuánto.  
- **devolverDepositos()**: Devuelve el dinero a los que no ganaron (menos un 2% para gas).

---

## ¿Cómo lo hice?

- Usé Solidity versión 0.8.30  
- Programé el contrato en Remix y lo desplegué en la red de prueba Scroll Sepolia  
- Usé eventos para avisar cuando hay una nueva oferta y cuando termina la subasta  
- El dueño es quien puede cerrar la subasta y devolver los depósitos

- ## Autor

Este trabajo fue hecho por Erick Madrid
