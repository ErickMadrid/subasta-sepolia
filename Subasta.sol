// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.30;

contract Subasta {
    address public owner;
    uint256 public inicio;
    uint256 public fin;
    uint256 public constanteExtension = 10 minutes;

    address public mejorOfertante;
    uint256 public mejorOferta;

    struct Oferta {
        uint256 monto;
        uint256[] historico;
        bool registrado;
    }

    mapping(address => Oferta) public ofertas;
    address[] public ofertantes;

    bool public finalizada;

    event NuevaOferta(address indexed ofertante, uint256 monto);
    event SubastaFinalizada(address ganador, uint256 monto);

    modifier soloDuranteSubasta() {
        require(block.timestamp >= inicio && block.timestamp <= fin, "Subasta no activa");
        _;
    }

    modifier soloOwner() {
        require(msg.sender == owner, "Solo el owner");
        _;
    }

    constructor(uint256 _duracionMinutos) {
        owner = msg.sender;
        inicio = block.timestamp;
        fin = inicio + (_duracionMinutos * 1 minutes);
    }

    function ofertar() external payable soloDuranteSubasta {
        require(msg.value > 0, "Valor nulo");
        Oferta storage o = ofertas[msg.sender];
        uint256 nuevaOferta = o.monto + msg.value;

        require(
            nuevaOferta >= mejorOferta + (mejorOferta * 5) / 100,
            "Debe superar en 5%"
        );

        if (!o.registrado) {
            o.registrado = true;
            ofertantes.push(msg.sender);
        } else {
            o.historico.push(o.monto);
        }

        o.monto = nuevaOferta;
        mejorOfertante = msg.sender;
        mejorOferta = nuevaOferta;

        if (fin - block.timestamp <= 10 minutes) {
            fin += constanteExtension;
        }

        emit NuevaOferta(msg.sender, nuevaOferta);
    }

    function retirarParcial(uint256 index) external {
        uint256[] storage hist = ofertas[msg.sender].historico;
        require(index < hist.length, "Indice invalido");
        uint256 monto = hist[index];
        hist[index] = 0;
        payable(msg.sender).transfer(monto);
    }

    function finalizarSubasta() external soloOwner {
        require(!finalizada, "Ya finalizada");
        require(block.timestamp > fin, "Aun activa");
        finalizada = true;
        emit SubastaFinalizada(mejorOfertante, mejorOferta);
    }

    function mostrarGanador() external view returns (address, uint256) {
        require(finalizada, "Subasta no finalizada");
        return (mejorOfertante, mejorOferta);
    }

    function mostrarOfertas() external view returns (address[] memory, uint256[] memory) {
        uint256[] memory montos = new uint256[](ofertantes.length);
        for (uint256 i = 0; i < ofertantes.length; i++) {
            montos[i] = ofertas[ofertantes[i]].monto;
        }
        return (ofertantes, montos);
    }

    function devolverDepositos() external soloOwner {
        require(finalizada, "Subasta no finalizada");

        for (uint256 i = 0; i < ofertantes.length; i++) {
            address addr = ofertantes[i];
            if (addr != mejorOfertante) {
                uint256 monto = ofertas[addr].monto;
                if (monto > 0) {
                    ofertas[addr].monto = 0;
                    uint256 reembolso = (monto * 98) / 100;
                    payable(addr).transfer(reembolso);
                }
            }
        }
    }
}
