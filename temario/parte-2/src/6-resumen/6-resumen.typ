#import "@preview/polylux:0.3.1": *
#import themes.metropolis: *

// ******************************* CONFIGURATION *******************************

#show: metropolis-theme.with(
)

#show math.equation: set text(font: "Fira Math")

#set text(font: "Fira Sans", size: 20pt, hyphenate: false)
#set par(justify: true)
#set strong(delta: 100)

// ***************************** CUSTOM ELEMENTS ******************************

#let frame(content, title: none) = {

  let header = [#text(fill:white, title)]

  set block(stroke: black, width: 100%, inset: (x: 0.5em, top: 0.4em, bottom: 0.5em))
  show stack: set block(breakable: false)
  show stack: set block(breakable: false, above: 0.8em, below: 0.5em)

  stack(
    block(fill: m-dark-teal, radius: (top: 0.2em, bottom: 0cm), header),
    block(fill: m-extra-light-gray, radius: (top: 0cm, bottom: 0.2em), content),
  )
}

#let definition(content, title: none) = {
  frame(content, title: title)
}

#let shadow(content) = {
   block(fill:luma(240),  inset: 12pt, radius: 4pt)[
     #content
   ]
}

#let colmath(x, color) = text(fill: color)[$#x$]

// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Aprendizaje por refuerzo",
  subtitle: "Resumen: métodos tabulares",
  extra: "manjavacas@ugr.es"
)

// *****************************************************************************

#slide(title: "Índice")[
  #metropolis-outline
]

// *****************************************************************************

#new-section-slide([Visión general])

// *****************************************************************************

#slide(title: [Resumen])[
  #align(center)[
    #box(height:400pt)[
      #image("images/summary.png") 
    ]
  ]
]

// *****************************************************************************

#new-section-slide([Conceptos clave])

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[
    #shadow[¿Diferencia entre problemas #alert[*episódicos*] y #alert[*continuados*]?]

    #pause

    - #text(fill:olive)[*Episódicos*]: problemas divisibles en episodios con un duración determinada, desde un estado inicial hasta un estado terminal.

    - #text(fill:purple)[*Continuados*]: no existen estados terminales.
  ]
]

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[
    #shadow[¿Diferencia entre #alert[*estado*] y #alert[*observación*]?]

    #pause

    - #text(fill:red)[*Estado*]: contiene información *completa* sobre el estado actual del entorno.

    - #text(fill:blue)[*Observación*]: contiene la información *parcial* percibida por el agente. Es un *subconjunto* de la información contenida en el estado.

    Diferencia entre MDP y POMDP.
  ]
]

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[
    #shadow[¿Diferencia entre #alert[*valor*] y #alert[*recompensa*]?]

    #pause

    - #text(fill:blue)[*Valor*]: retorno esperado a partir de un estado o par acción--estado.

    - #text(fill:green)[*Recompensa*]: valor inmediato percibido al alcanzar un estado o realizar una determinada acción desde un estado.
  ]
]

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[
    #shadow[¿Qué es el #alert[*retorno*]?]

    #pause

    #text(fill:purple)[*Retorno*]: recompensa acumulada al final de un episodio o secuencia de _time steps_. 
    
  ]
]

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[
    #shadow[¿Diferencia entre #alert[*exploración*] y #alert[*explotación*]?]

    #pause

    - #text(fill:olive)[*Exploración*]: elección de acciones subóptimas que pueden conducir a nuevas experiencias/transiciones/recompensas no percibidas.

    - #text(fill:red)[*Explotación*]: aplicación de la política (óptima) actual para maximizar una función de recompensa.
  ]
]

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[
    #shadow[¿Diferencia entre #alert[*predicción*] y #alert[*control*]?]

    #pause

    - #text(fill:blue)[*Predicción*]: estimación de las funciones de valor para una política dada. Consiste en *evaluar* una política.

    - #text(fill:purple)[*Control*]: encontrar la política óptima que maximice la recompensa acumulada. Implica *evaluación* y *mejora* de la política actual.
  ]
]

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[

    #shadow[¿Diferencia entre métodos #alert[*_on-policy_*] y #alert[*_off-policy_*]?]
  
    #pause
    
    - #text(fill:red)[*_On-policy_*]: la política empleada para generar experiencia y aprender es #alert[*la misma*] que se emplea para actuar.
  
    - #text(fill:blue)[*_Off-policy_*]: una política genera experiencia (#alert[*comportamiento*]) mientras que otra se emplea para actuar (#alert[*objetivo*]).
  
  ]
]

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[
    #shadow[¿Diferencia entre #alert[*_model-based_*] y #alert[*_model-free_*]?]

    #pause

    - #text(fill:blue)[*_Model-based_*]: métodos de RL basados en el aprendizaje y/o aprovechamiento de modelos para generar experiencia y *planificar* un comportamiento óptimo.

    - #text(fill:olive)[*_Model-free_*]: métodos de RL que no requieren un modelo del entorno y *aprenden directamente* a partir de interacción real.
  ]
]

// *****************************************************************************

#slide(title: [Conceptos clave])[
  #box(height:400pt)[



    #columns(2)[

    #shadow[#text(fill:olive)[*Programación dinámica*]]
    #text(size:17pt)[
      - Evaluación de la política.
      
      - Mejora de la política.
      
      - Iteración de la política.
  
      - DP síncrona _vs._ asíncrona.
      
      - Iteración de la política generalizada (GPI).
    ]
    

    #columns(2)[

      #shadow[#text(fill:orange)[*Bandits*]] 
      #text(size:12pt)[
        - Exploración _vs._ explotación.
  
        - $epsilon$-_greedy_.
        
        - _Upper Confidence Bound_
  
        - _Thompson Sampling_
  
        - Actualizaciones incrementales
  
        ]
  
      #colbreak()
  
      #shadow[#text(fill:blue)[*Planificación*]]
      
      #text(size:15pt)[
      - Dyna-Q
  
      - Dyna-Q+
  
      - MC _tree search_
        
      ]
    ]

    #colbreak()
    
    #shadow[#text(fill:red)[*Métodos basados en muestreo*]]

    - Monte Carlo.
    
    - Inicios de exploración.
    
    - _Importance sampling_.

    - _On-policy vs. off-policy_.
    
    - _TD learning_.
    
    - SARSA.
    
    - _Q-learning_.
    
    - _Expected SARSA_.

    - Métodos _n-step_.
    
    ]

  ]
]


// *****************************************************************************

#new-section-slide([Limitaciones])

// *****************************************************************************

#slide(title: [Métodos tabulares])[
  
  #shadow[Los métodos vistos hasta el momento se denominan #alert[*tabulares*] debido a la forma en que almacenan y gestionan la información.]

  Por ejemplo, en el caso de las *políticas*, estas pueden representarse como una *tabla* que relaciona estados y acciones, o estados, acciones y valores.

  - Ej. _Q-table_.

  _Asumimos que el número de estados y acciones es *discreto* y *limitado*, por lo que su gestión es computacionalmente viable._
  
]

// *****************************************************************************

#slide(title: [Limitaciones])[
  
  #shadow[#emoji.quest ¿Pero qué ocurre si el #alert[*espacio de estados*] / #alert[*acciones*] es *infinito*?] 

  #pause

  ... o lo suficientemente grande como para ser *inabarcable* por los métodos vistos #emoji.face.think

  #pause

  #v(2cm)

  #text(size:30pt)[
    #align(center)[#shadow[¡Lo veremos en la siguiente parte! #emoji.confetti #emoji.face]]
  ]
  
]


// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Aprendizaje por refuerzo",
  subtitle: "Resumen: métodos tabulares",
  extra: "manjavacas@ugr.es"
)