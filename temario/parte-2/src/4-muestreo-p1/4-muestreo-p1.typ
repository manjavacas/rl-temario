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
  subtitle: "Métodos basados en muestreo (1)",
  extra: "manjavacas@ugr.es"
)

// *****************************************************************************

#slide(title: "Índice")[
  #metropolis-outline
]

// *****************************************************************************

#slide(title: "Limitaciones de la programación dinámica")[

  #box(height:400pt)[
    Hemos visto que los algoritmos de #alert[programación dinámica] son *poco escalables* a medida que el tamaño del *espacio de estados/acciones* aumenta.
  
    Además, asumíamos algo que rara vez se da en la práctica: la disponibilidad y conocimiento íntegro de un #alert[*modelo del entorno*].
    
    - Son métodos _model-based_.
  
    #pause
  
    #shadow[#emoji.quest *¿Existe una forma más sencilla/escalable de obtener el valor de los diferentes estados/acciones?*]
  
    Recordemos que #alert[_valor de un estado_ = _retorno esperado_], esto es:
      #text(size:22pt)[
        $ v_pi (s) = EE_pi [G_t | S_t = s] $
      ]
  ]
]

// *****************************************************************************

#focus-slide[Métodos basados en muestreo \ #text(size:19pt)[_Sample-based learning methods_]]

// *****************************************************************************

#let sm = text[Métodos basados en _sampling_]

#slide(title: [#sm])[

  Los #alert[métodos _sampling_] ofrecen una serie de ventajas que facilitan la estimación de valores/obtención de políticas óptimas en MDPs.

  - Su principal ventaja es que *no requieren un modelo del entorno*.

  En términos generales, su funcionamiento consiste en:

  #shadow[
    1. Acumular #alert[experiencia] mediante la #alert[interacción] con el entorno.
    2. *PREDICCIÓN*: estimar el valor de estados/acciones.
    3. *CONTROL*: obtener la política óptima asociada.
  ]

  Comenzaremos estudiando los métodos Monte Carlo, y posteriormente veremos otras alternativas.
  
]

// *****************************************************************************

#new-section-slide[Predicción Monte Carlo]

// *****************************************************************************

#slide(title: "Predicción Monte Carlo")[

  #frame(title:"Método Monte Carlo")[
    Técnica computacional empleada para estimar resultados mediante la generación de múltiples muestras aleatorias.
  ]

  #v(1cm)

  La idea básica detrás de la #alert[prediccón Monte Carlo] (_Monte Carlo prediction_) es seguir múltiples trayectorias aleatorias desde diferentes estados.

  - Para aproximar el valor de un estado, calculamos la *media* de las recompensas acumuladas obtenidas cada vez que se visitó.
  
  - No requiere un *modelo* del entorno (es #alert[_model-free_]).
  
]

// *****************************************************************************

#slide(title: "Ejemplo")[
 #align(center)[
    #box(height:400pt)[
      #image("images/mc-sample.png")
    ]
 ]
]

// *****************************************************************************

#slide(title: "Predicción Monte Carlo")[

  #box(height:400pt)[
    #grid(
      columns:(3fr, 1fr),
      grid.cell(
        box[
          #shadow[Monte Carlo requiere solamente #alert[*experiencia*.]]
      
          - No asume conocimiento alguno de las *dinámicas del entorno*... $p(s',r|s,a)$.
        
          - No emplea valores esperados $EE$, sino *resultados empíricos*.
        ]
      ),
      grid.cell(
          align(center)[#image("images/dice.png", width:70%)]
      )
    )
    
    #shadow[Permite la resolución de problemas de RL a partir del *promedio de las recompensas finales obtenidas* (_average sample returns_).]
  
    - Se trata de un #alert[proceso de mejora episodio-a-episodio], ya que solamente conocemos el _return_  (recompensa acumulada final) al terminar un episodio.
  
    - Decimos que es un aprendizaje #alert[basado en resultados completos] (_vs._ parciales).
  ]
    
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[

    Tratamos de estimar $v(s)$, con $gamma = 0.5$
    
    - Recordemos que $v(s) = EE[G_t | S_t = s]$
    
    Comenzamos realizando una #alert[trayectoria aleatoria]:

    #v(1cm)

    #align(center)[#image("images/mc-bot-1.png", width:105%)]

  ]
    
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[

    Acumulamos #alert[experiencia]...

    #v(1cm)

    #align(center)[#image("images/mc-bot-2.png", width:105%)]
  
  ]
    
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[

    #v(0.3cm)
    #align(center+top)[#image("images/mc-bot-2.png", width:105%)]

    Calculamos el #alert[retorno] para cada estado:

    #v(0.9cm)
    
    #columns(2)[

      $ G_0 = R_1 + gamma G_1 $
      $ G_1 = R_2 + gamma G_2 $
      $ G_2 = R_3 + gamma G_3 $     

      #colbreak()

      $ G_3 = R_4 + gamma G_4 $
      $ G_4 = R_5 + gamma G_5 $
      $ G_5 = colmath(0, #red) $     
    ]
    
  ]
    
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[

    #v(0.5cm)
    #align(center+top)[#image("images/mc-bot-2.png", width:105%)]
    
    #columns(2)[

      $ G_0 = R_1 + gamma G_1 #uncover(range(5,6))[$colmath(= 3 + 0.5 dot 8 = 7, #red)$] $
      $ G_1 = R_2 + gamma G_2 #uncover(range(4,6))[$colmath(= 4 + 0.5 dot 8 = 8, #red)$] $
      $ G_2 = R_3 + gamma G_3 #uncover(range(3,6))[$colmath(= 7 + 0.5 dot 2 = 8, #red)$] $     

      #colbreak()

      $ G_3 = R_4 + gamma G_4 #uncover(range(2,6))[$colmath(= 1 + 0.5 dot 2 = 2, #red)$] $
      $ G_4 = R_5 + gamma G_5 #uncover(range(1,6))[$colmath(= 2 + 0.5 dot 0 = 2, #red)$] $
      $ G_5 = colmath(0, #red) $     
    ]
    
  ]
    
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[

    Valores estimados:

    #v(1cm)

    #align(center)[#image("images/mc-bot-3.png", width:105%)]
  
  ]
    
]

// *****************************************************************************

#slide(title: "Predicción Monte Carlo")[

  #box(height:400pt)[
    #align(center)[#image("images/mc-algo.png")]
  ]
    
]

// *****************************************************************************

#let fvev = text[Predicción _First-visit_ _vs._ _Every-visit_ ]

#slide(title: [#fvev])[

  - Denominamos a este método #alert[_First-visit Monte Carlo prediction_], porque sólo tenemos en cuenta la recompensa obtenida en la *primera visita* a cada estado.

  - Una alternativa es #alert[_Every-visit Monte Carlo prediction_], que tiene en cuenta *todas las visitas* a un mismo estado.

  #v(1cm)
  
  #text(size:22pt)[
    #align(center)[#shadow[Ambos convergen en $v_pi (s)$]]
  ]

  #v(1cm)
  
  Veamos exactamente en qué se diferencian...
    
]

// *****************************************************************************

#slide(title: [#fvev])[

  #box(height:400pt)[
    #columns(2,gutter:40pt)[
      #align(center)[#image("images/fv-mc.png", width:106%)]
      #colbreak()
      #align(center)[#image("images/ev-mc.png", width:110%)]
    ]
  ]
  
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #box(height:400pt)[
    #align(center)[
        #image("images/fv-ev-example.png", width:105%)
    ]
  ]
]


// *****************************************************************************

#slide(title: "Ejemplo")[
  #box(height:400pt)[
    
    #shadow[#text(size:20pt)[#alert[*_FIRST-VISIT_ MC*]] #text(size:19pt)[\ Consideramos las recompensas acumuladas a partir de la primera visita.]]
    
    #align(center+top)[
        #image("images/fv-example.png", width:85%)
    ]

    #columns(3, gutter: 30pt)[
      #text(size:18pt)[
        *Episodio 1: *
        
        $V(s_1) = 3+2+ -4 +4 -3 = bold(2)\ V(s_2) = -4 + 4 - 3 = bold(-3)  $
  
        #colbreak()
        
        *Episodio 2: *
        
        $V(s_1) = 3 -3 = bold(0)\  V(s_2) = -2 + 3 -3  = bold(-2) $

        #colbreak()

        #shadow[$V(s_1) = (2+0)/2 = bold(1)$\ #v(0.4cm) $V(s_2) = (-3 -2)/2 = bold(2.5)$]
      ]
    ]


  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #box(height:400pt)[

    #shadow[#text(size:20pt)[#alert[*_EVERY-VISIT_ MC*]] #text(size:19pt)[\ Consideramos las recompensas acumuladas a partir todas las visitas.]]
    
    #align(center+top)[
        #image("images/ev-example.png", width:85%)
    ]

      #columns(2, gutter: 170pt)[
        #text(size:18pt)[
          
          *Episodio 1: *
          
          $V(s_1) = (3+2-4+4-3) + (2-4+4-3) + (4-3) = bold(2)\ V(s_2) = (-4+4-3)+(-3)= bold(0)  $

          
 
          #colbreak()
          
          *Episodio 2: * 
          
          $V(s_1) = 3 -3 = bold(0)\  V(s_2) = (-2 + 3 -3) + (-3)  = bold(1) $

    
        ]
      ]

      #align(center)[
        #shadow[$V(s_1) = (2-1+1+0)/4 = bold(0.5)$ #h(4cm) $V(s_2) = (-3 -3 -2 -3)/4 = bold(2.75)$]
      ]
    ]

]

// *****************************************************************************

#slide(title: "Predicción Monte Carlo")[
 
  MC es una solución relativamente simple para aproximar funciones de valor/evaluar políticas.

  #shadow[
    Un aspecto importante de MC es que la estimación del valor de un estado #alert[*NO* depende de las estimaciones de valor de otros estados].

    - El #alert[valor de cada estado es independiente del resto], y *sólo depende de la recompensa acumulada al final del episodio*.

    - Es decir, no hay #alert[*_bootstrapping_*] (#alert[estimaciones a partir de estimaciones]).
  ]

  Esto puede ser útil cuando solamente queremos saber el valor de un subconjunto de estados (ignorando el resto).
  
]

// *****************************************************************************

#let bmc = text[Diagrama _backup_ de MC]

#slide(title: [#bmc])[

  #box(height:400pt)[
    #columns(2, gutter:1pt)[
      #v(2cm)
      
      El diagrama *_backup_* del método Monte Carlo representa cómo las estimaciones de valor de los estados requieren llegar hasta el final del episodio.
  
      Una vez obtenido el *retorno* (es decir, la #alert[recompensa acumulada al final del episodio]), dicha información se propaga hacia atrás.
  
      #colbreak()
  
      #align(center)[#image("images/backup-mc.png")]
    ]
  ]
]

// *****************************************************************************

#let bmc = text[Diagrama _backup_ de MC]

#slide(title: [#bmc])[

  #box(height:400pt)[
    #columns(2)[

      Si comparamos con los diagramas de los algoritmos de programación dinámica...

      #align(center)[#image("images/backup-dp.png", width:110%)]

      #align(left)[
        #shadow[
          - MC *no emplea _bootstrapping_*.
          - MC permite estimaciones para *subconjuntos de estados*.
        ]
      ]
      
      #colbreak()
  
      #align(center)[#image("images/backup-mc.png")]
      
    ]
  ]
]

// *****************************************************************************

#slide(title: "Estimación de valores de acción con MC")[

  #box(height:400pt)[

    Si no contamos con un modelo del entorno, es particularmente útil tratar de estimar directamente los #alert[_action-values_] (_vs. state-values_).

    #shadow[#alert[Con un modelo del entorno], los valores de los estados son suficientes para saber qué política seguir.]

        - Se mira "un paso adelante" y se decide a qué nuevo estado ir.

    #shadow[#alert[Sin un modelo], los valores de los estados *NO* son suficientes.]

        - Es necesario estimar de forma explícita el valor de cada acción.
        - Saber qué acción realizar en cada estado nos conduce directamente a una *política óptima*.
    
  ]
]

// *****************************************************************************

#slide(title: "Estimación de valores de acción con MC")[

  #box(height:400pt)[
      #shadow[*Con un modelo del entorno*, el agente sólo tiene que estimar los valores de los estados y actuar de forma _greedy_ para alcanzar su objetivo.]

      #align(center)[#image("images/with-model.png")]
  ]
]

// *****************************************************************************

#slide(title: "Estimación de valores de acción con MC")[

  #box(height:400pt)[
      #shadow[*Sin un modelo del entorno*, el agente necesita estimar los valores de cada par acción-estado...]

      #v(0.2cm)
      
      #align(center)[#image("images/without-model.png")]

      El agente aprende a elegir la mejor acción para cada estado $-->$ está aprendiendo directamente la *política óptima*.
  ]
]

// *****************************************************************************

#new-section-slide[Control Monte Carlo]

// *****************************************************************************

#slide(title: "Control Monte Carlo")[

  #shadow[#emoji.quest #h(0.5cm) ¿Cómo utilizar Monte Carlo para aproximar políticas óptimas?]

  Seguiremos la idea de #alert[GPI] (_Iteración de la Política Generalizada_), aplicando hasta convergencia:
    
      1. #alert[*Evaluación*] de la política
      2. #alert[*Mejora*] de la política
  
    #align(center)[
      #shadow[$ pi_0 -> q_0 -> pi_1 -> q_1 -> dots -> pi_* -> q_* $]
    ]
  
]

// *****************************************************************************

#slide(title: "GPI con Monte Carlo")[

  #box(height:450pt)[
    #columns(2)[
      
      _*Recordemos...*_
    
      En GPI se mantiene una *función de valor* y una *política* aproximadas.
      
       #emoji.chart.bar La #alert[función de valor] se actualiza progresivamente hasta aproximarse a la función de valor de la política actual.
      
       #emoji.chart.up Por otro lado, la #alert[política] siempre se mejora con respecto a la función de valor actual (de forma _greedy_).
  
      #colbreak()
      
      #align(center)[#image("images/iteration-loop.png", width:50%)]
    ]
  ]
  
]

// *****************************************************************************

#slide(title: "GPI con Monte Carlo")[

  #box(height:400pt)[
    #columns(2)[

      _*Recordemos...*_
      
      $ pi_0 ->^E q_pi_0 ->^I pi_1 ->^E q_pi_1 ->^I dots ->^I pi^* ->^E q_(pi^*) $
      
      Para cada función de valor $q$, la política _greedy_ correspondiente es aquella tal que $forall s in cal(S)$ elige de forma *determinista* una acción con valor máximo:

      $ pi(s) = op("argmax")_a q(s,a) $

      #colbreak()

      
      Es decir, #alert[$pi_(k+1)$ es siempre la política _greedy_ con respecto a $q_pi_k$].
      
      #shadow[#emoji.books Matemáticamente, se demuestra que cada $pi_(k+1)$ será uniformemente mejor que $pi_k$ o, al menos, igual (en ese caso, ambas políticas son óptimas).]
    ]

  ]
  
]

// *****************************************************************************

#slide(title: "GPI con Monte Carlo")[

    #let exp = text(size:14pt, fill:blue)[empleada\ para\ acumular\ experiencia]
    #let val = text(size:14pt, fill:olive)[valores\ estimados]
    #let pol = text(size:14pt, fill:red)[nueva\ política]
    #let new = text(size:14pt, fill:red)[nueva\ estimación]
  
    $ underbrace(pi_0, #exp) ->^E underbrace(q_pi_0, #val) ->^I underbrace(pi_1, #pol) ->^E underbrace(q_pi_1, #new) ->^I dots ->^I pi^* ->^E q_(pi^*) $

    De esta forma, MC es capaz de obtener *políticas óptimas* a partir de #alert[episodios muestreados] y sin ningún conocimiento del entorno.

    La estabilidad se alcanza cuando la política y la función de valor son óptimas.
  
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[
    #box(height:400pt)[
      Las recompensas son los valores en cada casilla.
      Asumimos $gamma = 1$.
      
      #align(center)[#image("images/control-mc.png", width:40%)]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-0.png", width:40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-1.png", width:40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-2.png", width:40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-3.png", width:40%)]

]

// *****************************************************************************

// #slide(title: "Ejemplo")[

//   #align(center)[#image("images/control-4.png", width:40%)]

// ]


// // *****************************************************************************

// #slide(title: "Ejemplo")[

//   #align(center)[#image("images/control-5.png", width:40%)]

// ]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-6.png", width:40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-7.png", width:40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-8.png", width:40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/q-s6.png", width:100%)]
      
      #colbreak()

      #v(2cm)
      
      $ q(s_6, #emoji.arrow.b.filled) = 10 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/q-s3.png", width:100%)]
      
      #colbreak()

      #v(2cm)

      $ q(s_6, #emoji.arrow.b.filled) = 10 $
      $ q(s_3, #emoji.arrow.b.filled) = (-1) + 10 = 9 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/q-s2.png", width:100%)]
      
      #colbreak()

      #v(2cm)

      $ q(s_6, #emoji.arrow.b.filled) = 10 $
      $ q(s_3, #emoji.arrow.b.filled) = 9 $
      $ q(s_2, #emoji.arrow.r.filled) = (-1) + 9 = 8 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/q-s5.png", width:100%)]
      
      #colbreak()

      #v(2cm)

      $ q(s_6, #emoji.arrow.b.filled) = 10 $
      $ q(s_3, #emoji.arrow.b.filled) = 9 $
      $ q(s_2, #emoji.arrow.r.filled) = 8 $
      $ q(s_5, #emoji.arrow.t.filled) = (-1) + 8 = 7 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/q-s4.png", width:100%)]
      
      #colbreak()

      #v(2cm)

      $ q(s_6, #emoji.arrow.b.filled) = 10 $
      $ q(s_3, #emoji.arrow.b.filled) = 9 $
      $ q(s_2, #emoji.arrow.r.filled) = 8 $
      $ q(s_5, #emoji.arrow.t.filled) = 7 $
      $ q(s_4, #emoji.arrow.r.filled) = (-1) + 7 = 6 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/q-s1.png", width:100%)]
      
      #colbreak()

      #v(2cm)

      $ q(s_6, #emoji.arrow.b.filled) = 10 $
      $ q(s_3, #emoji.arrow.b.filled) = 9 $
      $ q(s_2, #emoji.arrow.r.filled) = 8 $
      $ q(s_5, #emoji.arrow.t.filled) = 7 $
      $ q(s_4, #emoji.arrow.r.filled) = 6 $
      $ q(s_1, #emoji.arrow.b.filled) = (-1) + 6 = 5 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/control-0.png", width:100%)]
      
      #colbreak()
      
      #v(1cm)
      
      #align(center)[
        #table(
          columns: (auto, auto, auto, auto, auto),
          inset: 10pt,
          fill: (x, y) =>
            if x == 0 or y == 0 { gray.lighten(80%) },
          table.header(
            [], [#emoji.arrow.t.filled], [#emoji.arrow.b.filled], [#emoji.arrow.l.filled], [#emoji.arrow.r.filled]
          ),
          [$s_1$], [], [#alert[5]], [], [],
          [$s_2$], [], [], [], [#alert[8]],
          [$s_3$], [], [#alert[9]], [], [],
          [$s_4$], [], [], [], [#alert[6]],
          [$s_5$], [#alert[7]], [], [], [],
          [$s_6$], [], [#alert[10]], [], [],
          [$s_7$], [], [], [], [],
          [...], [...], [...], [...], [...],
        )
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[
    #box(height:400pt)[
      _Siguiente iteración..._
  
      #align(center)[#image("images/control-0.png", width:40%)]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-1.png", width:40%)]

]


// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-10.png", width:40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #align(center)[#image("images/control-11.png", width:40%)]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

    #box(height:400pt)[
    #columns(2)[
      
    #align(center)[#image("images/q-s7.png", width:70%)]
      
      #colbreak()

      #v(2cm)

      $ q(s_7, #emoji.arrow.r.filled) = -10 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

    #box(height:400pt)[
    #columns(2)[
      
    #align(center)[#image("images/q-s4-2.png", width:70%)]
      
      #colbreak()

      #v(2cm)

      $ q(s_7, #emoji.arrow.r.filled) = -10 $
      $ q(s_4, #emoji.arrow.b.filled) = (-1) + (-10) = -11 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

    #box(height:400pt)[
    #columns(2)[
      
    #align(center)[#image("images/q-s1.png", width:70%)]
      
      #colbreak()

      #v(2cm)

      $ q(s_7, #emoji.arrow.r.filled) = -10 $
      $ q(s_4, #emoji.arrow.b.filled) = -11 $
      $ q(s_1, #emoji.arrow.b.filled) = (-1) + (-11) = -12 $
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/control-0.png", width:100%)]
      
      #colbreak()
      
      #v(0.65cm)
      
      #align(center)[
        #table(
          columns: (auto, auto, auto, auto, auto),
          inset: 12pt,
          fill: (x, y) =>
            if x == 0 or y == 0 { gray.lighten(80%) },
          table.header(
            [], [#emoji.arrow.t.filled], [#emoji.arrow.b.filled], [#emoji.arrow.l.filled], [#emoji.arrow.r.filled],
          ),
          [$s_1$], [], [#alert[$(5+(-12))/2 = -3.5$]], [], [],
          [$s_2$], [], [], [], [8],
          [$s_3$], [], [9], [], [],
          [$s_4$], [], [#alert[-11]], [], [6],
          [$s_5$], [7], [], [], [],
          [$s_6$], [], [10], [], [],
          [$s_7$], [], [], [], [#alert[-10]],
          [...], [...], [...], [...], [...],
        )
      ]
    ]
  ]

]


// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[#image("images/later.jpg")]
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/control-0.png", width:100%)]
      
      #colbreak()
      
      #align(center)[
        Los *valores* convergen...
        #table(
          columns: (auto, auto, auto, auto, auto),
          inset: 10pt,
          fill: (x, y) =>
            if x == 0 or y == 0 { gray.lighten(80%) },
          table.header(
            [], [#emoji.arrow.t.filled], [#emoji.arrow.b.filled], [#emoji.arrow.l.filled], [#emoji.arrow.r.filled]
          ),
          [$s_1$], [6], [7], [6], [7],
          [$s_2$], [7], [8], [6], [8],
          [$s_3$], [8], [9], [7], [8],
          [$s_4$], [6], [6], [7], [8],
          [$s_5$], [7], [-10], [7], [9],
          [$s_6$], [8], [10], [8], [9],
          [$s_7$], [7], [6], [6], [-10],
          [$s_8$], [-], [-], [-], [-],
          [$s_9$], [-], [-], [-], [-],
        )
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Ejemplo")[

  #box(height:400pt)[
    #columns(2)[
      
      #align(center)[#image("images/mc-policy.png", width:100%)]
      
      #colbreak()
      
      #align(center)[
        Obtenemos la *política* _greedy_...
        #table(
          columns: (auto, auto, auto, auto, auto),
          inset: 10pt,
          fill: (x, y) =>
            if x == 0 or y == 0 { gray.lighten(80%) },
          table.header(
            [], [#emoji.arrow.t.filled], [#emoji.arrow.b.filled], [#emoji.arrow.l.filled], [#emoji.arrow.r.filled]
          ),
          [$s_1$], [6], [#alert[7]], [6], [#alert[7]],
          [$s_2$], [7], [#alert[8]], [6], [#alert[8]],
          [$s_3$], [8], [#alert[9]], [7], [8],
          [$s_4$], [6], [6], [7], [#alert[8]],
          [$s_5$], [7], [-10], [7], [#alert[9]],
          [$s_6$], [8], [#alert[10]], [8], [9],
          [$s_7$], [#alert[7]], [6], [6], [-10],
          [$s_8$], [-], [-], [-], [-],
          [$s_9$], [-], [-], [-], [-],
        )
      ]
    ]
  ]

]

// *****************************************************************************

#slide(title: "Exploración en métodos MC")[

  #box(height:500pt)[
    Un problema de MC a la hora de estimar valores es que algunos pares acción-estado #alert[podrían no visitarse nunca]...
  
    #align(center)[#image("images/big-problem.png", width:40%)]

    Si el agente sigue una política completamente aleatoria, es posible que ciertas acciones/estados rara vez se seleccionen, especialmente en *entornos complejos*.
  ]
]

// *****************************************************************************

#slide(title: "Exploración en métodos MC")[

  Este #alert[sesgo en la selección de acciones] conduce a una *exploración desigual* y a una *estimación sesgada* de los valores.

  El problema es similar si nos encontramos en un entorno *no determinista*...

  #align(center)[#image("images/mc-problem.png", width:60%)]
]

// *****************************************************************************

#slide(title: "Exploración en métodos MC")[

  #emoji.compass #emoji.robot Es necesario favorecer la #alert[*exploración*] del agente.

  Debemos asegurar *que todos los pares acción-estado se acaben visitando*. Para ello:
  
    - Las acciones que puedan tomarse partiendo de un estado $s in cal(S)$ nunca tendrán probabilidad $= 0$ (#alert[política estocástica]).

    - Para evitar problemas asociados a entornos no deterministas (donde las transiciones a algunos estados pueden ser poco frecuentes), podemos emplear #alert[*inicios de exploración*] (_exploring starts_).
]

// *****************************************************************************

#slide(title: "Inicios de exploración")[

  Se trata de una forma de asegurar #alert[exploración continua].

  - Todo episodio empieza desde un *par estado-acción aleatorio*:

  #let t = text[Dependientes de $pi$,$p$]
  #let m = text[$s_1, a_1, s_2, a_2, dots$]
  
  $ underbrace(#alert[$s_0, a_0$], "Aleatorios"), underbrace(#m, #t) $
  
  - Cada par estado-acción tiene una probabilidad *no nula* de ser seleccionado #alert[al principio de un episodio]: 
  
    $ mu(s,a) > 0, forall s in cal(S), a in cal(A) $
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/es-0.png")
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/es-1.png")
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/es-2.png")
  ]
]

// *****************************************************************************

#slide(title: "Ejemplo")[
  #align(center)[
    #image("images/es-3.png")
  ]
]

// *****************************************************************************

#slide(title: "Inicios de exploración")[
  #align(center)[
    #box(height:500pt)[
      #image("images/mc-exploring-algorithm.png", width:90%)
    ]
  ]
]

// *****************************************************************************

#slide(title: "Inicios de exploración")[

  #box(height:400pt)[
    El #text(fill:red)[*problema*] es que #alert[*no siempre* podemos emplear inicios de exploración].
  
    - Existen problemas en los que es difícil comenzar es un par estado-acción aleatorio.
    
    #shadow[Es difícil asegurar que un agente pueda empezar desde toda configuración posible, especialmente en problemas lo suficientemente complejos.]
  
    #columns(2, gutter:1pt)[
      #text(size:18pt)[
        - Problemas con espacios de estados / acciones *continuos*.
        - Ineficiencia: estados / acciones *inaccesibles* desde el estado inicial real.
        - ...
      ]
      #colbreak()

      #align(center)[#image("images/warning.png",width:40%)]
    ]
    #pause
    #text(size:24pt, fill:red)[*¿SOLUCIÓN?*]
  ]
]

// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Aprendizaje por refuerzo",
  subtitle: "Métodos basados en muestreo (1)",
  extra: "manjavacas@ugr.es"
)