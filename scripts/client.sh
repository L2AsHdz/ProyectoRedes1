#!/bin/bash

continue=true

if [[ ! -n "$1" ]]; then
	continue=false
fi

if [[ ! -n "$2" ]]; then
	continue=false
fi

if $continue; then
	edificio=$1
	cliente=$2
	config=true

	echo "Borrando ip anterior"
	ip=$(ip a show enp7s0 | grep -Po '(?<=inet )[\d.]+/\d{2}')
	ip a del $ip dev enp7s0

	echo "Borrando rutas configuradas"
	ip r | grep via | grep enp7s0 | while read ruta; do ip r del $ruta; done

	echo ""
	case $edificio in
	A)
		gateway='10.10.51.1'
		mascara='/27'
		case $cliente in
		a)
			echo "Configurando cliente A.$cliente"
			newIp='10.10.51.2'
			;;
		b)
			echo "Configurando cliente A.$cliente"
			newIp='10.10.51.3'
			;;
		c)
			echo "Configurando cliente A.$cliente"
			newIp='10.10.51.4'
			;;
		*)
			echo "No existe el cliente $cliente en el edificio $edificio"
			config=false
			;;
		esac
		routes+=('10.10.54.0/29')
		routes+=('10.10.52.0/28')
		;;
	B)
		gateway='10.10.52.1'
		mascara='/28'
		case $cliente in
		a)
			echo "Configurando cliente B.a"
			newIp='10.10.52.2'

			routes+=('10.10.51.0/27')
			;;
		b)
			echo "Configurando cliente B.b"
			newIp='10.10.52.3'

			routes+=('10.10.51.0/27')
			routes+=('10.10.54.0/29')
			;;
		c)
			echo "Configurando cliente B.c"
			newIp='10.10.52.4'

			routes+=('10.10.54.0/29')
			;;
		*)
			echo "No existe el cliente $cliente en el edificio $edificio"
			config=false
			;;
		esac
		;;
	C)
		gateway='10.10.53.1'
		mascara='/26'
		case $cliente in
		a)
			echo "Configurando cliente C.$cliente"
			newIp='10.10.53.2'
			;;
		b)
			echo "Configurando cliente C.$cliente"
			newIp='10.10.53.3'
			;;
		c)
			echo "Configurando cliente C.$cliente"
			newIp='10.10.53.4'
			;;
		d)
			echo "Configurando cliente C.$cliente"
			newIp='10.10.53.5'
			;;
		e)
			echo "Configurando cliente C.$cliente"
			newIp='10.10.53.6'
			;;
		*)
			echo "No existe el cliente $cliente en el edificio $edificio"
			config=false
			;;
		esac
		routes+=('10.10.55.0/26')
		;;
	E)
		gateway='10.10.54.1'
		mascara='/29'
		case $cliente in
		a)
			echo "Configurando cliente E.a"
			newIp='10.10.54.2'

			routes+=('10.10.52.0/28')
			routes+=('10.10.51.0/27')
			;;
		b)
			echo "Configurando cliente E.b"
			newIp='10.10.54.3'

			routes+=('10.10.55.0/26')
			routes+=('10.10.51.0/27')
			routes+=('10.10.52.0/28')
			;;
		e)
			echo "Configurando cliente E.e"
			newIp='10.10.54.4'

			routes+=('10.10.51.0/27')
			routes+=('10.10.52.0/28')
			;;
		g)
			echo "Configurando cliente E.g"
			newIp='10.10.54.5'

			routes+=('10.10.55.0/26')
			;;
		*)
			echo "No existe el cliente $cliente en el edificio $edificio"
			config=false
			;;
		esac
		;;
	D)
		gateway='10.10.55.1'
		mascara='/26'
		case $cliente in
		a)
			echo "Configurando cliente D.a"
			newIp='10.10.55.2'

			routes+=('10.10.54.0/29')
			routes+=('10.10.53.0/26')
			;;
		b)
			echo "Configurando cliente D.b"
			newIp='10.10.55.3'

			routes+=('10.10.54.0/29')
			;;
		f)
			echo "Configurando cliente D.f"
			newIp='10.10.55.4'

			routes+=('10.10.53.0/26')
			;;
		g)
			echo "Configurando cliente D.g"
			newIp='10.10.55.5'

			routes+=('10.10.53.0/26')
			;;
		*)
			echo "No existe el cliente $cliente en el edificio $edificio"
			config=false
			;;
		esac
		;;
	esac

	if $config; then

		echo ""
		echo "Configurando ip $newIp"
		ip a add $newIp$mascara dev enp7s0

		echo "Configurando gateway $gateway"

		echo ""
		echo "Configurando routes"

		for r in ${routes[@]}; do
			echo "Creando route hacia $r"
			ip r add $r via $gateway dev enp7s0
		done

		ip -c a show enp7s0
		ip -c r | grep via
    else
        echo "Configuracion cancelada..."
    fi
else
	echo "No se ingresaron parametros"
fi
