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

	case $edificio in
	A)
		salida='enp8s0'
		case $cliente in
		a)
			echo "Configurando cliente A.$cliente"
			newIp='10.10.51.2'
			origenes+=('10.10.54.4')
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
		origenes+=('10.10.52.2')
		origenes+=('10.10.52.3')
		;;
	B)
		salida='enp9s0'
		case $cliente in
		a)
			echo "Configurando cliente B.a"
			newIp='10.10.52.2'

			origenes+=('10.10.51.2')
            origenes+=('10.10.51.3')
            origenes+=('10.10.51.4')
			;;
		b)
			echo "Configurando cliente B.b"
			newIp='10.10.52.3'
			;;
		c)
			echo "Configurando cliente B.c"
			newIp='10.10.52.4'
            origenes+=('10.10.54.2')
            origenes+=('10.10.54.4')
			;;
		*)
			echo "No existe el cliente $cliente en el edificio $edificio"
			config=false
			;;
		esac
		;;
	C)
		salida='enp9s0'
		case $cliente in
		a)
			echo "Configurando cliente C.$cliente"
			newIp='10.10.53.2'
            origenes+=('10.10.55.4')
            origenes+=('10.10.55.5')
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
		;;
	E)
		salida='enp9s0'

		case $cliente in
		a)
			echo "Configurando cliente E.a"
			newIp='10.10.54.2'
            origenes+=('10.10.51.2')
            origenes+=('10.10.51.3')
            origenes+=('10.10.51.4')
            origenes+=('10.10.52.3')
			;;
		b)
			echo "Configurando cliente E.b"
			newIp='10.10.54.3'

            origenes+=('10.10.51.2')
            origenes+=('10.10.51.3')
            origenes+=('10.10.51.4')
            origenes+=('10.10.52.3')
			;;
		e)
			echo "Configurando cliente E.e"
			newIp='10.10.54.4'
			;;
		g)
			echo "Configurando cliente E.g"
			newIp='10.10.54.5'

            origenes+=('10.10.55.2')
			;;
		*)
			echo "No existe el cliente $cliente en el edificio $edificio"
			config=false
			;;
		esac

		;;
	D)
		salida='enp8s0'
		case $cliente in
		a)
			echo "Configurando cliente D.a"
			newIp='10.10.55.2'
            origenes+=('10.10.53.2')
            origenes+=('10.10.53.3')
            origenes+=('10.10.53.4')
            origenes+=('10.10.53.5')
            origenes+=('10.10.53.6')
			;;
		b)
			echo "Configurando cliente D.b"
			newIp='10.10.55.3'

            origenes+=('10.10.54.3')
			;;
		f)
			echo "Configurando cliente D.f"
			newIp='10.10.55.4'
			;;
		g)
			echo "Configurando cliente D.g"
			newIp='10.10.55.5'
			;;
		*)
			echo "No existe el cliente $cliente en el edificio $edificio"
			config=false
			;;
		esac
		;;
	esac

	if $config; then
		echo "Generando reglas del clien $cliente en el router $edificio"
		for o in ${origenes[@]}; do
			$(echo "iptables -A FORWARD -s $o -d $newIp -m state --state NEW -j ACCEPT" >> $3)
		done
		$(echo "iptables -A FORWARD -o $salida -m state --state NEW -j REJECT" >> $3)
	fi
else
	echo "No se ingresaron parametros"
fi
