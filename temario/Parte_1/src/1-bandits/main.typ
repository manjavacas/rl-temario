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

#let red = red

// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Aprendizaje por refuerzo",
  subtitle: "Bandits",
  extra: "manjavacas@ugr.es"
)

// *****************************************************************************

#slide(title: "Índice")[
  #metropolis-outline
]

// *****************************************************************************

#slide(title: "Motivación")[

  - Ya conocemos las diferencias entre aprendizaje #alert[instructivo] y #alert[evaluativo].

  #pause
  
  - También hemos visto que el aprendizaje #alert[evaluativo] es la base del #alert[aprendizaje por refuerzo].

  #pause

  #shadow[
  *OBJETIVO*: profundizar sobre el _aprendizaje evaluativo_ en un #alert[entorno simplificado], en el cual no es necesario aprender a actuar en más de una situación.
  
    - Es una simplificación de los problemas de _reinforcement learning_ completos.
    - Esto nos permitirá introducir algunos conceptos básicos.
  ]
]

// *****************************************************************************

#let b = text[_Bandits_]

#new-section-slide([#b])

// *****************************************************************************

#slide(title: "Entornos no asociativos")[

  - Los problemas de RL pueden entenderse como problemas de #alert[toma de decisiones].
    - Un agente recibe información del entorno y *decide* qué acción realizar.
    
  - En un problema de RL *completo*, consideramos múltiples estados, así como diferentes acciones a realizar dependiendo de qué estado perciba el agente.
    - Las acciones pueden afectar el estado del entorno y, por tanto, influir en las recompensas futuras.

 -  Antes de abordar problemas de RL complejos, estudiaremos un #alert[problema simplificado] donde el concepto de _estado_ no es tan relevante, y únicamente se tienen en cuenta las _acciones_ a realizar por el agente.
    - Es lo que llamos un #alert[entorno no asociativo].
]

// *****************************************************************************

#slide(title: [#b])[
  #align(center)[#image("images/rl-bandits.png", width: 90%)]
]


// *****************************************************************************

#let x = text[El problema de los _K-armed bandits_]

#slide(title: [#x])[
  
  #box(height: 350pt,
   columns(2, gutter:1pt)[
      - #alert[*_K-armed bandits_*], también llamado #alert[_multi-armed bandit problem_] o "problema de las _tragaperras multi-brazo_" (#emoji.face.inv).
      
      - Problema clásico en RL y teoría de la probabilidad. 
      
      - Extrapolable a campos tan variados como ensayos clínicos, gestión empresarial, economía, _marketing_...
      
      - Existen muchas variantes, pero nos centraremos en la versión más básica del problema.
    
      #figure(image("images/bandit.png", width: 60%), caption: "Armed bandit", numbering: none) 
   ]
  )
]

// *****************************************************************************

#slide(title: [#x])[

  #box(height: 400pt,
    columns(2, gutter: 20pt)[
        #figure(image("images/bandits.png", width: 100%), caption: "K-armed bandits", numbering: none) 
  
        #v(0.8cm)
        
        Tenemos un número arbitrario ($K$) de máquinas tragaperras.
        
        #colbreak()
    
        - En cada instante de tiempo $t$, accionamos una máquina y recibimos una recompensa (#emoji.money.wings).
        
        - Cada máquina puede comportarse de forma diferente.
        
        - Desconocemos la *distribución de recompensas* de cada máquina.
  
        #shadow[
        #alert[*OBJETIVO*]: obtener la mayor cantidad de dinero posible (*recompensa acumulada*).
  
        ]
      ]
  )
]

// *****************************************************************************

#slide(title: [#x])[

  #box(height: 400pt,
    columns(2, gutter: 20pt)[
        #figure(image("images/bandits_3.png", width: 90%), caption: "3-armed bandits", numbering: none) 
        
        #align(center)[
          #shadow[
              $b_1$ : $mu = 10, sigma = 2$
              
              $b_2$ : $mu = 10, sigma = 4$
              
              $b_3$ : $mu = 7, sigma = 2$
          ]
          #text(size:13pt)[_Distribuciones de recompensas_: medias y desviaciones típicas]
        ]
  
        #colbreak()
  
        #align(center)[#image("images/distribs.png")]
      ]
  )
]

// *****************************************************************************

#slide(title: [#x])[

  #box(height: 400pt,
    columns(2, gutter: 30pt)[
  
        #shadow[
          Buscamos maximizar la #alert[recompensa acumulada] concentrando nuestras acciones en las mejores acciones.
        ]
         - Las recompensas medias de $b_1$ y $b_2$ son similares. No obstante, $b_2$ es más conservador (menor $sigma ->$ valores más próximos a la media).
         
         - Jugar $b_2$ es más arriesgado (mayor $sigma$), porque puede darnos mejores recompensas que $b_2$ y $b_3$, pero también recompensas mucho peores.
         
         - Jugar $b_3$ no parece una buena idea...
  
        #colbreak()
  
        #align(center)[#image("images/distribs.png")]
  
      ]
  )
]

// *****************************************************************************

#slide(title: [#x])[

  #box(height: 400pt,
    columns(2, gutter: 30pt)[
  
        #figure(image("images/distribs.png", width: 70%), numbering: none) 
  
        #align(center)[
          
          #alert[*Espacio de acciones*]:
      
          $cal(A) = {a_1, a_2, a_3}$
  
        ]
        
        #colbreak()
  
        #align(center)[#image("images/bandit_loop.png")]
  
      ]
  )
]


// *****************************************************************************

#slide(title: [#x])[

  #box(height: 400pt,
    columns(2, gutter: 30pt)[
  
        #figure(image("images/distribs.png", width: 70%), numbering: none) 
  
        #align(center)[
          
          #alert[*Espacio de acciones*]:
      
          $cal(A) = {a_1, a_2, a_3}$
  
        ]
        
        #colbreak()
  
        #align(center)[#image("images/bandit_loop_3.png")]
  
      ]
  )
]

// *****************************************************************************

#slide(title: "Valor de una acción")[

  El #alert[*valor de una acción*] (_action-value_) es la recompensa que esperamos obtener al realizarla:

    #alternatives-match((
      "1" : [
        $ q_*(a) = EE[R_t | A_t = a] $
        #v(7cm)
      ],
      "2" : [
        $ underbracket(q_*(a), "Valor de\nla acción") = underbracket(EE[R_t | A_t = a], "Recompensa esperada\nal realizar dicha acción") $

        #shadow[
          $EE$ representa el *valor esperado*:
          #align(center)[$EE(x) = sum x #v(1cm) P(X=x)$]
        ]
            
        #text(size:15pt)[
        - Suma ponderada de los posibles valores de $x$ por sus probabilidades.
        
        - Relevante en #alert[problemas estocásticos] donde $R_t$ viene dada por una distribución de probabilidad.
        ]
      ],
    ))
]

// *****************************************************************************

#slide(title: "Problemas deteministas y estocásticos")[

  #box(height: 400pt,
    columns(2, gutter: 30pt)[
  
      #frame(title:"Problema determinista")[
        Toda acción $a in cal(A)$ siempre tiene las mismas consecuencias.
      ]
  
      #v(1cm)

      #frame(title:"Problema estocástico")[
          Realizar una acción $a in cal(A)$ puede conducirnos a diferentes recompensas o estados a partir de situaciones similares.
      ]
        
      #colbreak()
  
      #figure(image("images/deterministic.png", width: 70%), numbering: none) 

      #figure(image("images/stochastic.png", width: 100%), numbering: none) 
  
    ]
  )

]

// *****************************************************************************

#slide(title: "Valor de una acción")[

  Si desarrollamos la fórmula:

  #align(center)[
    #alternatives-match((
      "1" : [
        $q_*(a) = EE[R_t | A_t = a] = sum_r r #v(1cm) p(r|a)$
      ],
      "2" : [
        $q_*(a) = EE[R_t | A_t = a] = colmath(underbracket(sum_r r #h(0.2cm) p(r|a), "Suma ponderada de\nlas recompensas por\n sus probabilidades"), #red)$
      ],
    ))
  ]

  #pause
  #v(1cm)

   #box(height: 145pt,
    columns(2, gutter: 30pt)[

      #figure(image("images/stochastic.png"), numbering: none) 
      
      #colbreak()

      $q_*(a) &= 0 dot 0.25 + 10 dot 0.25 + dot (-1) dot 0.5 \
        &= 0 + 2.5 - 0.5 = bold(2)
      $
  
    ]
  ) 
]

// *****************************************************************************

#slide(title: "Valor de una acción")[

  Como, a priori, no conocemos los valores reales de cada acción, consideramos valores estimados:

  $ Q_t (a) approx q_*(a) $

  Estos valores se irán aproximando a los reales a medida que ampliemos nuestra *experiencia*.

  Pero...
  
  #align(center)[
    #shadow[
      _¿Cómo aproximamos progresivamente los valores de las acciones?_
    ]
  ]
]

// *****************************************************************************


#let x = text[Exploración _vs._ explotación]

#new-section-slide[#x]

// *****************************************************************************

#slide(title: [#x])[
  
   #box(height: 350pt,
    columns(2, gutter: 60pt)[

      Consideremos el siguiente caso:
      
      - Tenemos 3 bandits y, por tanto, 3 posibles acciones.
    
      - Inicialmente, desconocemos el valor de cada acción: $q_*(a) = 0, forall a in cal(A)$.
    
      - Por tanto, comenzamos eligiendo una acción arbitraria. Es decir, #alert[exploramos].

      #colbreak()

      #figure(image("images/exploration_1.png", width: 120%), numbering: none) 
    ]
  )
]

// *****************************************************************************

#slide(title: [#x])[
  
   #box(height: 400pt,
    columns(2, gutter: 60pt)[

      - El agente elige $a_1$ y recibe una recompensa $r_1 = 1$.

      - Posteriormente, convendrá explorar $a_2$ y $a_3$ para comprobar si son mejores opciones.

      #shadow[*Explorar* implica sacrificar recompensas inmediatas conocidas para probar alternativas hasta el momento no contempladas.]

      #text(size:19pt)[
      Esta inversión podría llevarnos a obtener mayores recompensas _a largo plazo_.
      ]

      #colbreak()

      #figure(image("images/exploration_2.png", width: 120%), numbering: none) 
    ]
  )
]

// *****************************************************************************

#slide(title: [#x])[
  
  - Es una idea similar a elegir entre un *restaurante* de confianza o uno que no has visitado nunca... #emoji.cutlery
  - ...o entre tu género de *películas* favorito y otro que no sueles ver... #emoji.camera.movie 
  - ...o entre un *producto* que sueles comprar y otro que podría interesarte... #emoji.cart 

  _¿Intuyes las posibles aplicaciones?_

  #pause

  #v(1cm)
  
  #align(center)[
      #grid(
        columns: (200pt, 200pt),
        gutter: 0.25pt,
        image("images/netflix.png", width: 40%),
        image("images/amazon.png", width: 40%),
      )
  ]
]

// *****************************************************************************

#slide(title: [#x])[
  
   #box(height: 400pt,
    columns(2, gutter: 60pt)[

      - El agente elige $a_2$ y recibe una recompensa $r_2 = 10$.

      #colbreak()

      #figure(image("images/exploration_3.png", width: 120%), numbering: none) 
    ]
  )
]

// *****************************************************************************

#slide(title: [#x])[
  
   #box(height: 400pt,
    columns(2, gutter: 60pt)[

      #only(1)[- El agente elige $a_3$ y recibe una recompensa $r_3 = 5$.]

      #only(2)[
        En $t=3$ hemos realizado todas las acciones posibles y recibidas sus correspondientes recompensas.

        A partir de aquí podemos:

        #text(size:20pt)[

          *a)* Actuar de forma _*greedy*_ ("voraz"), #alert[*explotando*] indefinidamente la mejor acción ($a_2$).
          
          *b)* Mantener un comportamiento aleatorio, #alert[*explorando*] continuamente las distribuciones de recompensa asociadas a cada acción.
        ]
      ]

      #colbreak()

      #figure(image("images/exploration_4.png", width: 120%), numbering: none) 
    ]
  )
]

// *****************************************************************************

#slide(title: [#x])[
  
   #box(height: 210pt,
    columns(2, gutter: 3pt)[

      #align(center)[#image("images/tradeoff.png", width: 90%)]

      #colbreak()

      No es posible *explorar* y *explotar* a la vez, lo que conduce a un *conflicto*.
        - #text(size:15pt, fill:m-light-brown)[_Exploration-exploitation trade-off_]

      Elegir una estrategia u otra dependerá de diferentes factores: incertidumbre, estimaciones, tiempo restante...
    ]
  )
  #shadow[
    Trataremos de buscar un *balance* entre exploración y explotación, siguiendo un comportamiento #alert[*$bold(epsilon)$-greedy*].
  ]
]

// *****************************************************************************

#let z = text[$epsilon$-greedy]

#slide(title: [#z])[

    #box(height: 300pt,
    columns(2, gutter: 1pt)[

        La estrategia $epsilon$-greedy consiste en:

          #v(0.5cm)
      
          - *Explotar* (ser _greedy_ con respecto a la mejor acción) con probabilidad #alert[$bold(1 - epsilon)$].

          #v(0.2cm)
          
          - *Explorar* (elegir una acción aleatoria) con probabilidad #alert[$bold(epsilon)$].
    

        #colbreak()
      
        #align(center)[#image("images/balance.png", width: 60%)]
      ]
  )
]

// *****************************************************************************

#slide(title: [#z])[
  - Para poder actuar de forma _greedy_ necesitamos saber qué acción es la mejor.

  - Pero una acción puede no darnos siempre la misma recompensa...

  #align(center)[
    #shadow[¿Cómo determinamos el valor de una acción?]
  
    #image("images/rewards_distrib.png", width: 50%)
  ]
]

// *****************************************************************************

#let w = text[Estimación de _action--values_]

#new-section-slide([#w])

// *****************************************************************************

#slide(title: [#w])[

  Existen diferentes formas de estimar el valor de una acción.

  Un método a considerar es la #alert[media muestral] (_sample-average method_):

  #box(height: 200pt,
    columns(2, gutter: 1pt)[
        
      #set text(size:25pt)
      #align(center)[ 
        #shadow[$ Q_t (a) = (sum_(i=1)^(t-1) R_(i,a)) / (sum_(i=1)^(t-1) n_(i,a)) $]
      ]
      #v(0.2cm)
      #set text(size:20pt)
      $ t -> infinity, #h(0.5cm) Q_t (a) = q_*(a) $

      #colbreak()

      - El valor estimado de una acción es la suma de las recompensas ofrecidas hasta el momento entre el número de veces que se ha elegido.

      - Si $t$ tiende a $infinity$, el valor estimado $Q_t (a)$ convergerá en el valor real $q_* (a)$.
    ]
  )
]

// *****************************************************************************

#let u = text[Acciones _greedy_]

#slide(title: [#u])[

  #shadow[¿Cómo emplear el valor estimado para elegir una acción?]

  Selección de acciones #alert[_greedy_]:

  #align(center)[
    #shadow[
      $ A_t = op("argmax")_a Q_t (a) $
    ]
  ]
  
  - Seleccionar la acción con el mayor valor estimado.

  - Si varias acciones tienen el mismo valor, podemos fijar un criterio (ej. selección aleatoria, la primera, etc.).
]

// *****************************************************************************

#let u = text[Acciones $epsilon$-_greedy_]

#slide(title: [#u])[

  #shadow[¿Cómo emplear el valor estimado para elegir una acción?]

  #alert[$epsilon$-_greedy_] combina la estrategia _greedy_ con la probabilidad $epsilon$ de explorar:

  #align(center)[
    #shadow[
      $ A_t = cases(
        op("argmax")_a Q_t (a) text("                        con prob.") 1-epsilon\
        a ~ op("Uniform")({a_1, a_2, dots a_k})text("         con prob.") epsilon
      )$
    ]
  ]
  
  - Cuanto menor sea $epsilon$, más tardaremos en converger en los valores reales.

  - Es posible ir reduciendo $epsilon$ con el paso del tiempo (a medida que los valores convergen).
]

// *****************************************************************************

#slide(title: "Ejemplo")[

  Consideremos el espacio de acciones: $cal(A) = {a_1, a_2}$

  #shadow[¿Cuál es la probabilidad de elegir $a_2$ siguiendo una estrategia $epsilon$-_greedy_ con $epsilon = 0.5$?]

  #let s = text[Probabilidad #linebreak() de que la acción #linebreak() elegida sea $a_2$]

  #align(center)[
    #alternatives-match((
      "1" : [
      
      ],
      "2" : [
        $ P(a_2) = 0.5 dot 0.5 = bold(0.25) $
      ],
      "3" : [
        $ P(a_2) = underbracket(colmath(0.5, #red), "Probabilidad\nde explorar") dot underbracket(colmath(0.5, #red), #s) = 0.25 $
      ],
    ))
  ]
]

// *****************************************************************************

#slide(title: "¿Qué método elegir?")[

  Podemos asumir que la elección de un método u otro se realizará cuando todas las acciones hayan sido probadas, al menos, una vez.    

  - Si las recompensas son #alert[valores únicos] ($sigma = 0$), elegiremos siempre la acción con mejores resultados.
      - En este caso, *_greedy_* es mejor.

  #pause
  
  - Si las recompensas se corresponden con una #alert[distribución de probabilidad] ($sigma > 0$), nos interesa no perder la posibilidad de explorar.
      - Por tanto, es mejor $bold(epsilon)$*-_greedy_*.
      - Especialmente en problemas con _noisier rewards_ $->$ mayor varianza de las distribuciones.
]

// *****************************************************************************

#slide(title: "No estacionareidad")[

    #box(height: 400pt,
    columns(2, gutter: 30pt)[

      #frame(title: "Problema no estacionario")[
        Decimos que un problema de decisión es #alert[no estacionario] si las distribuciones de recompensa varían con el tiempo.
      ]
        
      #align(center)[#image("images/stationarity.png", width: 70%)]

      #colbreak()

      - Una acción, _a priori_, mala puede mejorar con el tiempo, y viceversa.
      
      - Es un fenómeno muy común en aprendizaje por refuerzo.

      En este tipo de problemas, la mejor estrategia es $epsilon$-_greedy_, porque nunca se descarta la posibilidad de explorar y, por tanto, de #alert[reaprender las distribuciones de recompensa].
    ]
  )
]

// *****************************************************************************

#let p = text[Cálculo incremental de _action-values_]

#new-section-slide([#p])

// *****************************************************************************

#slide(title: "Valor estimado de una acción")[

  Previamente hemos propuesto estimar el valor de las acciones de la siguiente forma:

   #align(center)[ 
        #shadow[$ Q_t (a) = (sum_(i=1)^(t-1) R_(i,a)) / (sum_(i=1)^(t-1) n_(i,a)) $]
    ]

    El problema de este cálculo es que requiere mantener en *memoria* todas las recompensas obtenidas para cada acción en el tiempo.

    - En problemas con un gran espacio de acciones, o prolongados en el tiempo, este método es inviable en términos de escalabilidad.

    *SOLUCIÓN*: #alert[cálculo incremental de la media].
]

// *****************************************************************************

#let t = text[Cálculo incremental del _action-value_]

#slide(title: [#t])[

  #box(height: 400pt,
    columns(2, gutter: 20pt)[
       Si desarrollamos la fórmula para el cálculo del _action-value_ medio, podemos conseguir que este cálculo sea *incremental*.
      
      #shadow[
        No depende de todas las recompensas anteriores, sino únicamente del *_action-value_ actual* y de la *última recompensa* obtenida.
      ]

      #colbreak()
      
      $ Q_(n+1) &= colmath(1/n sum_(i=1)^n R_i, #red) \
        &= 1/n (R_n + sum_(i=1)^(n-1) R_i) \
        &= 1/n (R_n + (n-1) 1 / (n-1) sum_(i=1)^(n-1) R_i) \
        &= 1/n (R_n + (n-1) Q_n) \
        &= 1/n (R_n + n Q_n - Q_n) \
        &= colmath(Q_n + 1/n (R_n - Q_n), #blue)
      $
    ]
  )
]

// *****************************************************************************

#slide(title: [#t])[

    $ Q_(n+1) = 1/n sum_(i=1)^n R_i = Q_n + 1/n (R_n - Q_n) $

    Se trata de una regla de actualización incremental (#alert[_incremental update rule_]) bastante frecuente en RL:

    #align(center)[
      #shadow[
        $ op("nuevoValor") <- op("valorActual") + op("stepSize") (op("objetivo") - op("valorActual")) $
      ]
    ]

    O bien:

    #align(center)[
      #shadow[
        $ v_(t) <- v_t + alpha[G_t - v_t], #h(0.3cm) alpha in (0,1] $
      ]
    ]
]

// *****************************************************************************

#slide(title: [#t])[
  
  #let a = $frac(1,N(A))$
  
  $ Q(A) <- Q(A) + underbracket(#a, "step\nsize") dot underbracket([underbracket(R, "objetivo") - underbracket(Q(A), "estimación\nactual")], "error de estimación") $

  #v(1cm)
  
    - El #alert[error de estimación] se reduce a medida que las #alert[estimaciones] se acercan al #alert[objetivo].

    - Indica la diferencia entre la recompensa obtenida y el valor actual.
        - Determina cuánto nos hemos equivocado en nuestra estimación más reciente.  
]

// *****************************************************************************

#slide(title: [#t])[

  #let a = $frac(1,N(A))$
  
  $ Q(A) <- Q(A) + underbracket(#a, "step\nsize") dot underbracket([underbracket(R, "objetivo") - underbracket(Q(A), "estimación\nactual")], "error de estimación") $

  #v(1cm)
  
    - El #alert[_step-size_] pondera la importancia que damos al error de estimación.
        - Determina el peso de la nueva información recibida.
        
    - Lo que hacemos es añadir un pequeño ajuste al valor anterior de la acción, que depende de la diferencia entre la recompensa obtenida y nuestra estimación anterior del valor de la acción.
]

// *****************************************************************************

#slide(title: "Ejemplo: piedra, papel, tijeras")[

  #align(center)[
    R = $+1$ si se gana #h(1cm) R = $0$ si se pierde o empata #h(1cm) $alpha = 1/N$
    #table(
        columns: (auto, auto, auto, auto, auto, auto),
        inset: 9.7pt,
        align: center,
        fill: (x, y) => if y == 0 {silver},
        table.header(
          [*t*], [*Yo*], [*Rival*], [*Recompensa*], [*Actualización*], [$bold(Q(op("tijeras")))$],
        ),        
        [0], [-], [-], [-], [-], [0],
        [1], [#emoji.scissors], [#emoji.rock], [0], [$Q(op("tijeras")) = 0 + 1 (0 - 0)$], [0],
        [2], [#emoji.scissors], [#emoji.page], [+1], [$Q(op("tijeras")) = 0 + 1/2 (1 - 0)$], [0.1],
        [3], [#emoji.scissors], [#emoji.rock], [0], [$Q(op("tijeras")) = 0.5 + 1/3 (0 - 0.5)$], [0.09],
        [4], [#emoji.scissors], [#emoji.scissors], [0], [$Q(op("tijeras")) = 0.335 + 1/4 (0-0.335)$], [0.081],
        [$dots$], [$dots$], [$dots$], [$dots$], [$dots$], [$dots$],
        [N-1], [-], [-], [-], [-], [0.33],
    )
  ]
  
]

// *****************************************************************************

#slide(title: "Ejemplo: piedra, papel, tijeras")[

  #align(center)[
    ¿Y si variamos el _step size_? #h(1cm) $alpha = 0.1$
    #table(
        columns: (auto, auto, auto, auto, auto, auto),
        inset: 9.7pt,
        align: center,
        fill: (x, y) => if y == 0 {silver},
        table.header(
          [*t*], [*Yo*], [*Rival*], [*Recompensa*], [*Actualización*], [$bold(Q(op("tijeras")))$],
        ),        
        [0], [-], [-], [-], [-], [0],
        [1], [#emoji.scissors], [#emoji.rock], [0], [$Q(op("tijeras")) = 0 + bold(0.1) (0 - 0)$], [0],
        [2], [#emoji.scissors], [#emoji.page], [+1], [$Q(op("tijeras")) = 0 + bold(0.1) (1 - 0)$], [0.5],
        [3], [#emoji.scissors], [#emoji.rock], [0], [$Q(op("tijeras")) = 0.5 + bold(0.1) (0 - 0.5)$], [0.335],
        [4], [#emoji.scissors], [#emoji.scissors], [0], [$Q(op("tijeras")) = 0.335 + bold(0.1) (0-0.335)$], [0.25125],
        [$dots$], [$dots$], [$dots$], [$dots$], [$dots$], [$dots$],
        [N-1], [-], [-], [-], [-], [0.33],
    )
  ]
  
]

// *****************************************************************************

#let m = text[Elección del _step size_]

#slide(title: [#m])[

  La principal diferencia entre _step sizes_ es la velocidad de convergencia:

  - $alpha = 1/N$ supone una convergencia más lenta a medida que aumenta $N$. Esto provoca que actualizaciones más pequeñas y menos impactantes con el paso del tiempo.
    
    #shadow[Deseable si queremos dar más peso a las experiencias tempranas.]
    
  - Si se utiliza un _step size_ constante, $alpha in (0,1]$, la estimación del _action-value_ converge más rápido hacia su valor real, pero es más sensible a experiencias recientes.
    
    #shadow[Más efectivo cuando se desea dar más peso a las experiencias recientes.]
  
]

// *****************************************************************************

#let m = text[Elección del _step size_]

#slide(title: [#m])[

   #box(height: 400pt,
    columns(2, gutter: 20pt)[

      - En #alert[problemas estacionarios], los métodos basados en media muestral (_average sampling_) son apropiados, porque las distribuciones de probabilidad de las recompensas no varían con el tiempo.
      
        - Es decir, preferimos $alpha = 1/N$

      - En #alert[problemas no estacionarios], es más importante dar mayor peso a las recompensas recientes.

        - Por tanto, optamos por $alpha in (0,1]$
        
      #colbreak()
      
      #align(center)[#image("images/stationary.png", width: 20%)]
      #align(center)[#image("images/stationarity.png", width: 70%)]
      
    ]
  )
  
]

// *****************************************************************************

#let m = text[Elección del _step size_]

#slide(title: [#m])[

  #box(height:500pt)[
   #align(center)[#image("images/comparison.png")]
  ]
]

// *****************************************************************************

#new-section-slide("Valores iniciales")

// *****************************************************************************

#slide(title: "Valores iniciales optimistas")[

   #box(height: 400pt,
    columns(2, gutter: 30pt)[

      Los métodos vistos hasta el momento dependen en gran medida de las estimaciones de los _action-values_ iniciales. 
      
      Esto supone un #alert[sesgo] (_bias_).
      
      - En el método de la *media muestral*, si inicialmente todas las acciones tienen valor 0, habrá un sesgo hacia la primera acción de la que se obtenga una recompensa  > 0.
      
      - *El sesgo desaparece una vez hemos seleccionado todas las acciones posibles*.
        
      #colbreak()
      
      #align(center)[#image("images/bias.png", width: 100%)]
      
    ]
  )
        
]

// *****************************************************************************

#slide(title: "Valores iniciales optimistas")[

  #let l = text("A mayor número de\nexperiencias pasadas (n)\nmenor peso tienen las\nrecompensas anteriores")

  En métodos con #alert[_step size_ constante], el sesgo es permanente, aunque decrece con el tiempo:

  #align(center)[
    #alternatives-match((
      "1" : [
          $ Q_(n+1) &= Q_n + alpha[R_n - Q_n] \
                    &= (1-alpha)^n Q_1 + sum_(i=1)^n alpha(1 - alpha)^(n-i) R_i
          $
          #v(2.5cm)
      ],
      "2" : [
        $ Q_(n+1) &= Q_n + alpha[R_n - Q_n] \
                  &= (1-alpha)^n Q_1 + colmath(underbracket(sum_(i=1)^n alpha(1 - alpha)^(n-i) R_i, #l), #red)
        $
      ]
    ))
  ]  
]

// *****************************************************************************

#slide(title: "Valores iniciales optimistas")[

  En la práctica, el sesgo no suele ser un problema y a veces puede resultar muy útil.

  - Las estimaciones inciales pueden proporcionar #alert[conocimiento previo/experto] sobre qué recompensas podemos esperar de cada acción.

  - Un inconveniente es que estas estimaciones iniciales se convierten en un #alert[conjunto de parámetros que el usuario debe elegir], aunque por defecto pueden ser = 0.
]

// *****************************************************************************

#slide(title: "Sesgo como apoyo a la exploración")[

  Podemos utilizar el sesgo para guitar la exploración inicial de nuestro agente. Por ejemplo:

  #grid(
    columns: (1fr, 1fr, 1fr),
    align: center,
    gutter: 10pt,
    grid.cell(
      image("images/bias-1.png", width: 80%),
    ),
    grid.cell(
      image("images/bias-2.png", width: 80%),
    ),
    grid.cell(
      image("images/bias-3.png", width: 80%),
    ),
    grid.cell(
      text(size:11pt)[
        #shadow[
          Se asignan falsos valores iniciales de\ +100 a cada acción, a pesar de que los\ valores reales estén en [-2, +2].
        ]
      ]
    ),
    grid.cell(
      text(size:11pt)[
        #shadow[
          Se elige una acción en base a su valor estimado inicial. Podría ser la mejor, pero sigue siendo peor que los valores iniciales del resto de acciones.
        ]
      ]
    ),
    grid.cell(
      text(size:11pt)[
        #shadow[
          De esta forma, se aprovecha el sesgo para favorecer naturalmente la *exploración* inicial de todas las acciones posibles.
        ]
      ]
    )
  )
]

// *****************************************************************************

#slide(title: "Sesgo como apoyo a la exploración")[

  #text(size:19pt)[
    Utilizamos el sesgo para provocar la exploración inicial de todas/algunas acciones.
  
    #alert[*Esto permite que incluso un método _greedy_ explore*].
  
    - Se denomina #alert[_optimistic greedy_], porque emplea valores iniciales optimistas.
      - Puede dar lugar a mejores resultados que un $epsilon$-_greedy_ estándar.
    
    - La principal limitación es que la exploración es simplemente inicial (disminuye con el tiempo hasta desaparecer).
      - Esto hace que no sea útil en problemas *no estacionarios*.
  
    #shadow[
      "_The beginning of time occurs only once, and thus we should not focus on it too much_".

      #align(right)[
      #text(size:12pt)[
        #emoji.books _Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction (2nd ed.). MIT press. (p. 35)._]
      ]
    ]
  ]
 
]

// *****************************************************************************

#let u = text[_Upper-confidence-bound_]

#new-section-slide([#u])

// *****************************************************************************

#let e = text[Exploración $epsilon$-_greedy_]

#slide(title: [#e])[

  $epsilon$-_greedy_ fuerza la seleccion de acciones _non-greedy_ de forma indiscriminada:

  #align(center)[
    #shadow[
      $ A_t = cases(
        op("argmax")_a Q_t (a) text("                        con prob.") 1-epsilon\
        colmath(a ~ op("Uniform")({a_1, a_2, dots a_k})text("         con prob.") epsilon, #red)
      )$
    ]
  ]

  - Todas tienen la misma probabilidad.

  - No hay preferencia por aquellas más cercanas al valor _greedy_, o aquellas menos visitadas/desconocidas.

  Sería interesante explorar acciones *_non-greedy_* de acuerdo a su *potencial* para ser óptimas.
 
]

// *****************************************************************************

#slide(title: [#e])[

  #box(height: 400pt,
    columns(2, gutter: 20pt)[
  
      Para decidir qué acción explorar, podemos considerar:
      
      #text(size:19pt)[
        *A)* La cercanía al #alert[valor máximo actual]
          - El valor de la acción _greedy_
      
        *B)* La #alert[incertidumbre] en las estimaciones.
          - Qué acciones se han realizado menos ($n_i$)
      ]
      
      #colbreak()

      #align(center)[#image("images/exp-e-greedy.png", width: 95%)]
  
    ]
  )
   
]

// *****************************************************************************

#focus-slide("Si los combinamos...")

// *****************************************************************************

#slide(title: [#u])[

  La técnica del #alert[límite superior de confianza], o _Upper-confidence-bound_ (#alert[*UCB*]), nos permite balancear *valor* e *incertidumbre* a la hora de seleccionar acciones:


   #alternatives-match((
      "1" : [
        #align(center)[
          $ A_t = op("argmax")_a [ Q_t (a) + c #h(0.2cm) sqrt((ln t) / (N_t (a)))] $
        ]
        #v(2cm)
      ],
      "2" : [
        #v(0.5cm)
        #align(center)[
          $ A_t = op("argmax")_a [ Q_t (a) + colmath(c, #blue) #h(0.2cm) colmath(sqrt((ln t) / (N_t (a))), #red)] $
        ]
        #v(1cm)
        - $colmath(c>0, #blue)$ controla cuánto explorar.
        - $colmath(N_t (a), #red)$ indica el número de seleccione sprevias de la acción $a$.
          - Si $N_t (a) = 0$, se considera $a$ como la acción más preferible
      ],
    ))

]

// *****************************************************************************

#slide(title: [#u])[

  #text(size:18pt)[
  
    $ A_t = op("argmax")_a [colmath(underbracket(Q_t (a), "valor\nestimado"), #blue) + colmath(underbracket(c sqrt((ln t) / (N_t (a))), "incertidumbre"), #red)] $

  La selección de una acción depende de:
  
    1. Su #text(fill:blue)[valor estimado] hasta el momento.
    2. La #text(fill:red)[incertidumbre] sobre dicha acción.
      - Cada vez que una acción se selecciona, su incertidumbre se reduce.
      - Según pasa el tiempo, la incertidumbre sobre una acción vuelve a aumentar poco a poco.
  
    El coeficiente $c$ pondera la importancia que damos a la exploración.
  
    UCB reduce la exploración con el tiempo (el término de incertidumbre tiende a 0).
  ]
]

// *****************************************************************************

#slide(title: "Incertidumbre en las estimaciones")[
  Definimos #alert[intervalos de confianza] dentro de los cuales se encuentran los valores originales de las acciones y, por tanto, sus estimaciones:

  #align(center)[#image("images/ucb-1.png", width:53%)]
]

// *****************************************************************************

#slide(title: "Incertidumbre en las estimaciones")[

  #box(height: 400pt,
    columns(2, gutter: 20pt)[

      *Opción 1*. Elegir la acción con mayor incertidumbre (*exploración*).
      - A mayor incertidumbre, mayor creencia de que es bueno (_optimismo en presencia de incertidumbre_).
      - Elegimos la acción $colmath(a_1, #blue)$ en base a $c sqrt((ln t)/(N_t (a)))$.

      *Opción 2*. Elegir la acción con mayor valor estimado (*explotación*).
      - Elegimos la acción $colmath(a_2, #red)$ en base a $Q_t (a)$.

      #colbreak()

      #align(center)[#image("images/ucb-2.png")]

    ]
  )
]

// *****************************************************************************

#new-section-slide("Trabajo propuesto")

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #text(size:18pt)[
    
    - *Implementación* y *comparativa* de los métodos _greedy_, $epsilon$-_greedy_ y UCB para un ejemplo con $K$-armed bandits.
    
    - *_Thompson sampling_*
      - Definición y características.
      - Diferencias y similitudes con los métodos vistos.
      
    - *_Contextual bandits_*
      - ¿Qué son?
      - ¿Que relación podrían tener con las próximas lecciones?

    === Recursos interesantes
  
    - https://www.ma.imperial.ac.uk/~cpikebur/trybandits/trybandits.html
    - https://rlplaygrounds.com/reinforcement/learning/Bandits.html
    - https://youtu.be/bkw6hWvh_3k
  ]
]

// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Aprendizaje por refuerzo",
  subtitle: "Bandits",
  extra: "manjavacas@ugr.es"
)