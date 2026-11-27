#import "@preview/typslides:1.4.0": *

#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)
#set document(date: none)

#let colmath(x, color: red) = text(fill: color)[$#x$]

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Trust Region Policy Optimization (TRPO)",
  authors: "Antonio Manjavacas",
)

// *****************************************************************************

#table-of-contents(title: "Contenidos")

// *****************************************************************************

#slide(title: [Recapitulando...])[

  #framed[Los métodos basados en #stress[gradiente de la política] son capaces de aprender una política parametrizada $pi_bold(theta)$.]

  #cols[

  Una *política estocástica* define una distribución de probabilidad sobre las acciones $a$ dado un estado $s$. Esto es:

  #grayed[$ pi_bold(theta) (a|s) $]

  ][
    #image("images/politica_parametrizada.png")
  ]


]

// *****************************************************************************

#slide(title: [Recapitulando...])[

  #cols[

  Dada una acción $a_t$ en el estado $s_t$, definimos la #stress[función de ventaja] como:

  #grayed[$ A(s_t,a_t) = q(s_t, a_t) - v(s_t) $]

  ][
    #image("images/funcion_ventaja.png")
  ]
  
  Es decir, describe cómo de bueno es tomar la acción $a_t$ en el estado $s_t$ comparado con elegir aleatoriamente una acción de acuerdo a la política actual.
]

// *****************************************************************************

#slide(title: [Recapitulando...])[

  #stress[VPG] (_Vanilla Policy Gradient_) es un algoritmo _on-policy_ que actualiza la política en la dirección del gradiente del rendimiento:

  #grayed[$
    nabla_bold(theta) J(pi_bold(theta)) = EE_(tau ~ pi_bold(theta)) [ sum_(t=0)^T nabla_bold(theta) ln pi_bold(theta) (a|s) A(s_t, a_t)]
  $]

  La actualización de $theta$ se realiza de la siguiente forma:

  #grayed[$ bold(theta) <- bold(theta) + alpha nabla_bold(theta) J(pi_bold(theta)) $]

]

// *****************************************************************************

#title-slide("Limitaciones de VPG")

// *****************************************************************************

#slide(title: [Limitaciones de VPG])[

  Limitaciones de #stress[VPG]:

  #framed[1. Si las actualizaciones de $bold(theta)$ son *demasiado pequeñas*, el aprendizaje puede ser muy lento.]

  #framed[2. Si las actualizaciones de $bold(theta)$ son *demasiado grandes*, pueden conducir a estados de los que el agente no puede recuperarse.]

]

// *****************************************************************************

#slide(title: [Limitaciones de VPG])[

  #cols[
    #image("images/vpg_mala_politica_sin_recuperacion.png")
  ][

    - Los datos empleados para entrenar dependen de la política actual.

    - Una mala actualización da lugar a una mala política, que da lugar a malos datos de entrenamiento, que a su vez dan lugar a una política aún peor, etc.

  ]

]

// *****************************************************************************

#slide(title: [Limitaciones de VPG])[

  #cols[

    #framed[3. *Cambios pequeños* en $theta$ no resultan necesariamente en cambios pequeños en $pi_bold(theta)$.]

    Limitar el tamaño de la actualización de $theta$ no garantiza que la política no cambie demasiado.

  ][

    #image("images/theta_vs_politica.png")
  ]

]

// *****************************************************************************

#title-slide("Trust Region Policy Optimization")

// *****************************************************************************

#slide(title:"TRPO")[

  #stress[Trust Region Policy Optimization] (TRPO) es un algoritmo propuesto por Schulman et al. (2015) que mejora el rendimiento de los métodos basados en gradiente de la política.

  - Basado en gradiente de la política, _on-policy_.

  - Optimización de políticas basada en *región de confianza*.

  *Idea principal*: en vez de limitar el tamaño de las actualizaciones de $bold(theta)$, limitamos el tamaño de los cambios en la política $pi_bold(theta)$.

  #framed[#emoji.books Schulman, John, et al. _Trust region policy optimization_. International conference on Machine Learning. PMLR, 2015.]

]

// *****************************************************************************

#slide(title:"TRPO: ventajas")[

  Principales #stress[ventajas de TRPO]:

  #emoji.checkmark *Estabilidad*: evita que la política cambie demasiado en una sola actualización.

  #emoji.checkmark *Garantías teóricas*: mejora monotónicas en el rendimiento de la política (cada actualización da lugar a una política que es al menos tan buena como la anterior).

]

// *****************************************************************************

#slide(title:"Comparación de políticas")[


]