#import "@preview/typslides:1.1.1": *

#show: typslides.with(
  ratio: "16-9",
  theme: "bluey",
)

#set text(lang: "es")
#set text(hyphenate: false)

#set figure(numbering: none)

// *****************************************************************************

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Introducción",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)

// *****************************************************************************

#table-of-contents()

// *****************************************************************************

#title-slide("Contexto histórico")

// *****************************************************************************

#slide(title: "Contexto histórico")[

  #columns(2)[
    #stress[*1850*]. El filósofo y matemático *Alexander Bain* plantea el aprendizaje animal como un ejercicio basado en #stress[prueba y error].

    #stress[*1911*]. El psicólogo *Edward Thorndike* plantea la _ley del efecto_.
    - Propone la existencia de #stress[eventos de refuerzo] durante el aprendizaje animal que determinan el comportamiento.

    #image("images/law-effect.png", width: 100%)
  ]

]

// *****************************************************************************

#slide(title: "Contexto histórico")[

  #stress[*1927*]. *Iván Pávlov* formaliza el concepto de #stress[refuerzo].

  #columns(2)[
    #text(size: 18pt)[
      #framed(title: "Refuerzo")[Estímulo positivo o negativo que influencia un patrón de comportamiento.]

      - Determinados #stress[estímulos] pueden incrementar la probabilidad de que un animal realice ciertas acciones.

      - *Aprendizaje por refuerzo*. Modificación de la conducta mediante estímulos/refuerzos.
    ]

    #colbreak()

    #v(.7cm)

    Experimento del #stress[perro de Pávlov]:

    #image("images/dog.png", width: 100%)
  ]
]

// *****************************************************************************

#slide(title: "Contexto histórico")[

  #columns(2, gutter: 1.5cm)[

    #v(3cm)

    A partir de las ideas de *Pávlov*, *Watson*, *Thonrdike* y *Skinner* surge la psicología conductista, o #stress[conductismo].

    - Estudio de las leyes comunes que determinan el comportamiento humano y animal.

    #colbreak()

    #image("images/conductism.png")
  ]

]

// *****************************************************************************

#slide(title: "Contexto histórico")[
  El aprendizaje por refuerzo procede de los estudios sobre comportamiento animal, concretamente del #stress[condicionamiento operante] / #stress[aprendizaje instrumental].

  #columns(2, gutter: 1.5cm)[
    #framed[
      La _*Ley del Efecto de Thorndike*_ sugería que conductas con #text(fill:olive)[consecuencias satisfactorias] tienden a repetirse, mientras que aquellas que producen #text(fill:red)[consecuencias negativas] tienen menos probabilidades de volverse a realizar.
    ]
    #image("images/cat.jpg", width: 90%)
  ]
]

// *****************************************************************************

#slide(title: "Contexto histórico")[
  #columns(2, gutter: 1.5cm)[
    #framed[
      *Skinner* sostenía que los #text(fill:olive)[refuerzos positivos] o #text(fill:red)[negativos] pueden ser empleados para modificar el comportamiento, tanto en animales como humanos.
    ]
    #v(.3cm)

    - Experimento de la #stress[caja de Skinner].
    - Proyectos _Paloma_ y _ORCON_.

    #image("images/skinner.png", width: 100%)
  ]
]

// *****************************************************************************

#slide(title: "Contexto histórico")[
  #figure(image("images/rats.png"))
]

// *****************************************************************************

#focus-slide[
  ¿Pueden los ordenadores aprender así?
]

// *****************************************************************************

#title-slide("Aprendizaje por refuerzo en la IA")

// *****************************************************************************

#slide(title: "Aprendizaje por refuerzo en la IA")[

  #columns(2)[

    - #stress[*1950s*]. Control óptimo, procesos de decisión de Markov, programación dinámica.
      - *Richard Bellman*, *Ronald Howard*.

    #v(1cm)

    - #stress[*1970s*]. Planteamiento del aprendizaje mediante "prueba y error" en el marco de la inteligencia artificial.
      - *Marvin Minsky*, *Harry Klopf*, *Robert Rescorla*, *Allan Wagner*.

    #colbreak()

    - #stress[*1980s*]. _Temporal difference learning_, algoritmo _Q-learning_.
      - *Richard Sutton*, *Andrew Barto*, *Christopher Watkins*, *Peter Dayan*.

    #v(.5cm)

    #figure(image("images/suttonbarto.png"))
  ]
]


// *****************************************************************************

#slide(title: "Aprendizaje por refuerzo en la IA")[
  #columns(2, gutter: 2cm)[
    #v(4cm)
    #stress[*1992*]. IBM desarrolla _TD-Gammon_, alcanzando un nivel de habilidad humano en el juego del backgammon.
    #colbreak()
    #figure(image("images/tdgammon.jpg"))
  ]
]

// *****************************************************************************

#slide(title: "Aprendizaje por refuerzo en la IA")[
  #columns(2, gutter: 2cm)[
    #v(3cm)
    #stress[*2013*]. Investigadores de DeepMind desarrollan el algoritmo _DQN_, capaz de superar al ser humano en 22 juegos de la consola Atari.
    #colbreak()
    #figure(image("images/atari.jpg"))
  ]
]

// *****************************************************************************

#slide(title: "Aprendizaje por refuerzo en la IA")[
  #columns(2, gutter: 2cm)[
    - #stress[*2015--2017*]. _AlphaGo_, desarrollado por DeepMind, vence a varios de los mejores jugadores de Go del mundo.

    - #stress[*2017*]. _AlphaZero_, vence 100--0 a su predecesor y alcanza un nivel superhumano en ajedrez.

    - #stress[*2017--2019*]. _OpenAI Five_ vence a jugadores profesionales de Dota 2.

    - #stress[*2019*]. _AlphaStar_ vence a los mejores jugadores de StarCraft II.

    #colbreak()

    #v(1.4cm)

    #figure(image("images/alphago.jpg"))
  ]
]

// *****************************************************************************

#slide(title: "Aprendizaje por refuerzo en la IA")[
  - #stress[*2023*]. _Swift_ logra vencer a varios campeones mundiales en pilotaje de drones.

  - #stress[*2023--*]. Aprendizaje por refuerzo aplicado a mejorar las respuestas de agentes conversacionales como _ChatGPT_.

  #figure(image("images/drones.png", width: 60%))
]

// *****************************************************************************

#slide(title: "Aprendizaje por refuerzo en la IA")[

  #box(height: 400pt)[
    #v(.6cm)
    En los últimos años, encontramos algoritmos de #stress[reinforcement learning] aplicados a...

    #columns(2)[

      #framed()[
        - Robótica
        - Ciencias naturales
        - Sistemas de recomendación
        - Conducción autónoma
        - Energía
        - Economía e inversión
        - Aceleradores de partículas
        - Distribución eléctrica
        - Telecomunicaciones
        - ...
      ]

      #colbreak()

      #v(5cm)
      #align(center)[#text(size: 25pt)[_*¿Pero cómo funcionan?*_]]
    ]
  ]
]

// *****************************************************************************

#title-slide("Interacción Agente - Entorno")

// *****************************************************************************

#slide(title: "Aprendizaje por refuerzo: componentes")[

  Un problema de *_reinforcement learning_* (#stress[*RL*]) se compone de múltiples elementos.
  #v(1cm)
  #framed[
    Agente, entorno, estado, acción, recompensa, política...
  ]
  #v(1cm)
  Veamos en detalle en qué consiste cada uno de ellos...

]


// *****************************************************************************

#slide(title: "Agente")[

  #figure(image("images/agent.png", width: 20%))

  #v(1cm)

  #framed[
    Persigue un determinado #stress[objetivo]. Observa y actúa sobre un entorno.
  ]

  #v(.7cm)

  - _Colocar una pieza en un tablero._
  - _Moverse a una determinada posición._
  - _Aumentar/reducir la velocidad de un vehículo._

]

// *****************************************************************************

#slide(title: "Entorno")[

  #align(center)[
    #grid(
      columns: 2,
      image("images/chess.png", width: 45%), image("images/street.png", width: 45%),
    )
  ]

  #v(.5cm)

  #framed[
    #set text(size: 17.5pt)
    Sistema dinámico con el que el agente interactúa, recibiendo información o alterándolo.
  ]

  #v(.6cm)

  El agente percibe el #stress[estado] del entorno, y utiliza esta información para elegir qué #stress[acciones] realizar.

  - _Posición de las piezas en un tablero de ajedrez._
  - _Proximidad de un vehículo a los límites de la carretera._

]

// *****************************************************************************

#slide(title: "Recompensa")[
  #framed[
    Valor que indica #stress[cómo de buena o mala] es una _acción_ o _estado_ para el agente.
  ]

  #align(center)[
    #grid(
      columns: 2,
      image("images/good.png", width: 40%), image("images/bad.png", width: 40%),
    )
  ]

  - $R = +1$ por cada instante de tiempo en que un robot se mantiene en pie (#stress[refuerzo positivo]).
  - $R = -1$ por cada instante de tiempo que el agente tarda en salir de un laberinto (#stress[refuerzo negativo]).
  - $R = +1$ si el agente recomienda un producto y el usuario lo compra; $R = +0$ si no lo compra; $R = -1$ si lo compra y lo devuelve.
]

// *****************************************************************************

#focus-slide[
  Si combinamos todos estos elementos...
]

// *****************************************************************************

#slide(title: "Proceso de decisión de Markov")[
  #figure(image("images/rl.png", width: 70%))
]

// *****************************************************************************

#slide(title: "Acciones y estados")[
  Internamente, el agente establece una _correspondencia_ entre estados y acciones:
  #v(1cm)
  #figure(image("images/state_action.png", width: 65%))
  #v(1cm)
]

// *****************************************************************************

#slide(title: "Acciones y estados")[
  #v(1cm)
  ¿Pero cómo determina qué acción es más apropiada ante un determinado estado?
  #v(1cm)
  #figure(image("images/actions.png", width: 65%))
  #v(1cm)
]


// *****************************************************************************

#slide(title: "Política")[
  #figure(image("images/brain.png", width: 20%))

  #framed[
    Define el comportamiento del agente, y establece una #stress[correspondencia] entre _estados_ y _acciones_.
  ]

  #v(.7cm)

  Puede componerse de reglas simples, conocimiento experto, o requerir una gran cantidad de cálculos (ej. redes neuronales).
]

// *****************************************************************************

#slide(title: "En resumen...")[

  #columns(2)[

    - Método de aprendizaje computacional basado en la interacción de un #stress[agente] con su #stress[entorno].

    - El agente percibe el #stress[estado] del entorno y ejecuta #stress[acciones] que lo alteran.

    - Proceso iterativo, basado en prueba y error, donde el objetivo del agente es la maximización de una señal de #stress[recompensa].

    - Aprendizaje de una #stress[política] de comportamiento óptima.

    #colbreak()

    #v(2cm)

    #figure(image("images/rl.png"))
  ]
]

// *****************************************************************************

#title-slide("¿Por qué RL?")

// *****************************************************************************

#slide(title: "¿Por qué RL?")[
  #columns(2)[
    - Interés por emular el #stress[aprendizaje animal] basado en causa--efecto.

    - Diferencias relevantes con respecto al #stress[aprendizaje supervisado] y #stress[no supervisado].

    - RL no es solamente un conjunto de algoritmos destinados a resolver un problema, también incluye el #stress[planteamiento] y #stress[formalización] de dicho problema.

    #colbreak()
    #figure(image("images/paradigms.png"))
  ]
]

// *****************************************************************************

#slide(title: "Problemas de RL")[
  #columns(2)[
    #framed(title: "Formalización del problema")[
      #set text(size: 17pt)
      - ¿Problema episódico o continuado?
      - Modelo del entorno:
        - Variables observadas
        - Función de recompensa
        - _Model free_ vs. _model-based_
      - Definición del espacio de acciones (discreto o continuo)
    ]
    #colbreak()
    #framed(title: "Planteamiento de la solución")[
      - Sistemas de ecuaciones
      - Programación dinámica
      - Monte Carlo
      - _TD-learning_ (ej. _Q-learning_)
      - Métodos basados en gradiente
      - Aproximación de funciones (ej. _tile coding_, _Deep Reinforcement Learning_)
    ]
  ]
]

// *****************************************************************************

#slide(title: [RL _vs._ Aprendizaje Supervisado])[
  #grid(
    columns: (2fr, 1fr),
    gutter: 0.8cm,
    box[
      #text(size: 17pt)[
        - #stress[*Aprendizaje supervisado*] $->$ aprendizaje a partir de un conjunto de datos previamente *etiquetados* por un *supervisor externo*.

        - Cada ejemplo está compuesto por un conjunto de *características* ($X_1, X_2, X_3, ...$) y una *etiqueta* o *valor* a predecir ($Y$).

        - El objetivo de estos algoritmos es aprender a *generalizar* más allá de los datos empleados en su entrenamiento.

        #framed[
          El #stress[aprendizaje por refuerzo] permite aprender en base a la propia experiencia del agente, sin necesidad de un supervisor externo (vs. aprendizaje supervisado).
        ]

        No obstante, veremos cómo pueden combinarse.

      ]
    ],
    align(center)[
      #framed(title: "\"Reinforcement learning is supervised learning on optimized data\".")[

        #set text(size: 16pt)
        _What makes RL challenging is that, unless you’re doing imitation learning, actually acquiring that “good data” is quite challenging._

        #v(0.1cm)

        #set text(size: 12pt)
        #emoji.books #link("https://bair.berkeley.edu/blog/2020/10/13/supervised-rl/")
      ]
    ],
  )
]

// *****************************************************************************

#slide(title: [RL _vs._ Aprendizaje Supervisado])[
  #figure(image("images/rl-vs-sl.png", width: 90%))
]

// *****************************************************************************

#slide(title: [RL _vs._ Aprendizaje No Supervisado])[
  #grid(
    columns: (2fr, 1fr),
    gutter: 0.8cm,
    box[
      #text(size: 20pt)[
        - #stress[*Aprendizaje no supervisado*] $->$ aprendizaje de la estructura intrínseca de un conjunto de datos no etiquetados.

        - Tanto RL como ANS carecen de supervisión externa, pero sus objetivos son diferentes.

        #framed[
          Aunque tanto el aprendizaje no supervisado como el aprendizaje por refuerzo carecen de ejemplos de comportamiento “correcto”, el #stress[aprendizaje por refuerzo] trata de *maximizar una señal de recompensa*, en lugar de intentar encontrar *patrones comunes en conjuntos datos*.
        ]
      ]
    ],
    box[
      #text(size: 13pt)[
        #framed[
          "_Uncovering structure in an agent’s experience can certainly be useful in reinforcement learning, but by itself does not address the reinforcement learning problem of maximizing a reward signal. *We therefore consider reinforcement learning to be a third machine learning paradigm*, alongside supervised learning and unsupervised learning and perhaps other paradigms._"

          #set text(size: 12pt)
          #emoji.books Sutton & Barto. Reinforcement Learning. An introduction (2nd ed.)
        ]
      ]
    ],
  )
]

// *****************************************************************************

#slide(title: [Evaluar _vs._ instruir])[
  #set text(size: 17.5pt)

  Los algoritmos de RL *evalúan*, no *instruyen*.

  #framed[
    #stress[*Instruir*] (_instructive feedback_) consiste en indicar directamente cuál es la mejor decisión.

    - Siempre se toma la acción que se asume óptima.
    - Se basa en información completa del problema.
    - Se atribuye al aprendizaje supervisado.
  ]
  #v(-.5cm)
  #framed[
    #stress[*Evaluar*] (_evaluative feedback_) consiste en indicar cómo buena o mala ha sido una decisión, pero no si ha sido la mejor o peor posible.

    - Motiva la exploración.
    - Búsqueda de un comportamiento óptimo en base a información parcial del problema.
    - Es propio del aprendizaje por refuerzo.
  ]

  #set text(size: 10pt)
  \* _Ambos tipos de aprendizaje pueden combinarse._

]

// *****************************************************************************

#title-slide("Bibliografía recomendada")

// *****************************************************************************

#slide(title: "Bibliografía recomendada")[

  #text(size: 30pt, weight: "semibold")[#smallcaps("Libros")]

  - #underline[*Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction (2nd ed.). MIT press.*]

  - Morales, M. (2020). Grokking deep reinforcement learning. Manning Publications.

  - Zai, A., & Brown, B. (2020). Deep reinforcement learning in action. Manning Publications.

  - Szepesvári, C. (2010). Algorithms for reinforcement learning. Synthesis lectures on artificial intelligence and machine learning, 4(1), 1-103.

  #pagebreak()

  #text(size: 30pt, weight: "semibold")[#smallcaps("Recursos Web")]

  - https://github.com/huggingface/deep-rl-class
  - https://spinningup.openai.com/en/latest/index.html
  - https://julien-vitay.net/deeprl/

  #text(size: 30pt, weight: "semibold")[#smallcaps("Cursos")]

  - https://youtu.be/2pWv7GOvuf0
  - https://youtu.be/TCCjZe0y4Qc
  - http://rll.berkeley.edu/deeprlcourse/
  - https://youtu.be/nyjbcRQ-uQ8
  - https://www.coursera.org/specializations/reinforcement-learning
]

#front-slide(
  title: "Aprendizaje por refuerzo",
  subtitle: "Introducción",
  authors: "Antonio Manjavacas",
  info: "manjavacas@ugr.es",
)