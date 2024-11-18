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
  subtitle: "Planificación",
  extra: "manjavacas@ugr.es"
)

// *****************************************************************************

#slide(title: "Índice")[
  #metropolis-outline
]

// *****************************************************************************

#slide(title: [_Model-based_ _vs._ _Model-free_])[

  Hasta el momento hemos visto dos tipos de #alert[métodos de RL]:
  
  #v(1cm)

  #definition(title:[_*Model-based*_])[
    - Requieren un *modelo* del entorno.
    - Se basan en la *planificación* a partir de ese modelo.
    - Ej. programación dinámica, búsqueda heurística.
  ]

  #definition(title:[_*Model-free*_])[
    - No necesitan un *modelo* del entorno.
    - Se basan en la capacidad de *aprendizaje*.
    - Ej. Monte Carlo, TD.
  ]
  
]

// *****************************************************************************

#slide(title: [_Model-based_ _vs._ _Model-free_])[

  A pesar de sus diferencias, tanto los métodos _model-based_ como los _model-free_ persiguen *un mismo objetivo*: el cálculo de las #alert[funciones de valor óptimas] ($v^*, q^*$) y, por tanto, de una #alert[política óptima] ($pi^*$).

  También comparten el mismo _modus operandi_:

  #shadow[
    1. #alert[Mirar hacia delante], anticipando las consecuencias de posibles eventos futuros.
    2. Calcular un "#alert[valor de reserva]" (_backed-up_).
    3. Utilizar ese valor como herramienta (_target_, #alert[objetivo]) para aproximar $v$ o $q$.
  ]
]


// *****************************************************************************

#new-section-slide("Modelos y planificación")

// *****************************************************************************

#focus-slide[¿Qué es un *modelo*?]

// *****************************************************************************

#slide(title: [Modelo de un entorno])[

  #box(height:400pt)[
  #definition(title:[*Modelo de un entorno*])[Representación formal/abstracta del entorno que permite al agente #alert[predecir] las consecuencias de sus acciones. Esto es equivalente a *estimar transiciones*.]

  #v(1cm)
  
  #align(center)[#image("images/model.png", width:60%)]

  ]
]

// *****************************************************************************

#slide(title: [Tipos de modelos])[

  Si el entorno es #alert[estocástico], son posibles múltiples estados/recompensas siguientes, cada uno con diferente probabilidad.

  #shadow[Algunos modelos ofrecen una descripción de todas las probabilidades de transición. Estos se denominan #alert[*modelos de distribución*] (_distribution models_).]

  #shadow[Otros modelos solamente ofrecen como salida una de todas las posibles transiciones. Como esta transición se _muestrea_ en base a su probabilidad con respecto a todas las transiciones posibles, se denominan #alert[*modelos muestrales*] (_sample models_).]
  
]

// *****************************************************************************

#slide(title: [Tipos de modelos])[
  #align(center)[
    #box(height:500pt)[
      #align(center)[#image("images/distrib-model.png")]
      #align(center)[#image("images/sample-model.png")]
    ]
  ]
]

// *****************************************************************************

#slide(title: [Tipos de modelos])[

  En *programación dinámica*, por ejemplo, se trabaja con #alert[modelos de distribución], ya que conocemos las dinámicas del MDP:

    #align(center)[#shadow[ $ bold(p(s',r|s,a)) $ ]]

  #shadow[Los modelos de distribución son más robustos que los muestrales, ya que pueden utilizarse igualmente para producir muestras.]

  No obstante, en la práctica es mucho más fácil obtener un modelo muestral.
  
]

// *****************************************************************************

#slide(title: [Tipos de modelos])[

  #shadow[Un #alert[modelo muestral] puede emplearse para simular un episodio completo (de entre todos los posibles).]

  #shadow[Un #alert[modelo de distribución] permite obtener todos los posibles episodios y sus probabilidades.
  
    - Facilitan la _evaluación de riesgos_ asociados a una determinada transición.
  ]

  
]

// *****************************************************************************

#slide(title: [Modelo de un entorno])[

  #shadow[Los modelos permiten imitar/generar *experiencia*. Es decir, permiten *#alert[simular] las dinámicas del entorno modelado* y producir *experiencia simulada*.]

  - Permiten la toma de decisiones informada sin necesidad de interactuar con el entorno real.

  #emoji.bubble.thought La experiencia muestreada del modelo puede interpretarse como *_imaginar_* posibles escenarios que pueden ocurrir en el entorno real, y que dependen del entendimiento que se tiene del entorno.
  
]

// *****************************************************************************

#slide(title: [Ejemplo])[

  #align(center)[#image("images/plan-example.png", width:80%)]
  
]


// *****************************************************************************

#focus-slide([*Planificación*])

// *****************************************************************************

#slide(title: [Planificación])[
  
  #definition(title:[*Planificación*])[
    Cualquier proceso computacional que toma un *modelo* como entrada y produce o mejora una #alert[*política*] que interactúa con el entorno modelado.
  ]
  
  #v(1cm)
  
  #align(center)[#image("images/planning.png", width:60%)]

  #pause
  
  #text(size:14pt)[_Definir una "estrategia" para actuar sobre el entorno modelado._]
]

// *****************************************************************************

#slide(title: [Tipos de planificación])[
  
  #definition(title:[*Planificación sobre el espacio de estados*])[
    Búsqueda de una política óptima o camino óptimo hacia un objetivo a lo largo del #alert[*espacio de estados*].

    - Las acciones producen transiciones entre *estados* y las *funciones de valor* se calculan sobre dichos estados.

    - Es el tipo de planificación comunmente empleada en RL.
  ]

  #v(1cm)
  _Es el tipo de planificación que vamos a considerar._
  
]

// *****************************************************************************

#slide(title: [Tipos de planificación])[

  #definition(title:[*Planificación sobre el espacio de planes*])[
    Búsqueda a lo largo del espacio de planes/estrategias.

    - Las operaciones llevadas a cabo consisten en transformar un plan/estrategia en otro/a diferente.

    - Las funciones de valor (si las hay) se definen sobre el #alert[*espacio de planes*].
    
    - Estos métodos de planificación no son apropiados para problemas de decisión secuenciales y estocásticos como los que se abordan en RL, pero son comunes en otros ámbitos de la IA.
  ]

]


// *****************************************************************************

#slide(title: [Planificación sobre el espacio de estados])[

  #box(height:500pt)[
    Todo método de #alert[planificación sobre el espacio de estados] guarda una misma estructura:
  
    1. *Calcular las funciones de valor* como paso intermedio y fundamental de cara a mejorar la *política* existente.
  
    2. Dicho cálcula se realiza mediante *actualizaciones* u *operaciones de _backup_* aplicadas a experiencia simulada.
  
    #align(center)[#image("images/state-space-plan.png", width:90%)]
  ]
]

// *****************************************************************************

#slide(title: [Ejemplo: programación dinámica])[

  #box(height:500pt)[
    #align(center)[#image("images/state-space-plan.png", width:90%)]

    #v(0.6cm)

    1. Se realizan pasadas a lo largo del espacio de estados.
    
    2. Se genera, para cada estado, la distribución de todas las posibles transiciones.
    
    3. Cada distribución se emplea para calcular un valor _backup_. Este se utilizará como objetivo en las actualizaciones de los valores (el _update target_).

    4. Se actualiza el valor estimado del estado.
    
  ]
]


// *****************************************************************************

#slide(title: [Planificación sobre el espacio de estados])[

  Otros métodos de planificación sobre el espacio de estados *se ajustan también a esta estructura*, variando únicamente:

  1. La *forma de actualizar* los valores.
  
  2. El *orden* en que se realizan estas actualizaciones.
  
  3. Cuánto *tiempo* se mantiene la información retenida (_backed-up_).

  #v(0.9cm)

  #align(center)[#image("images/state-space-plan.png", width:90%)]
]

// *****************************************************************************

#slide(title: [Planificación _vs._ aprendizaje])[

  La diferencia entre planificaicón y aprendizaje es que 
  
  - la *#alert[planificacion] emplea experiencia simulada*, generada por un *modelo*, 
  - mientras que el *#alert[aprendizaje] se basa en experiencia real* generada por el *entorno*.

  #shadow[Tanto *planificacion* como *aprendizaje* buscan estimar las funciones de valor mediante operaciones _backup_.]

  - Esto permite que múltiples ideas y algoritmos puedan transferirse de unos métodos a otros.

  Por ejemplo, métodos de aprendizaje que emplean experiencia simulada en vez de experiencia real.

]

// *****************************************************************************

#slide(title: [Ejemplo: _Random-sample one-step tabular Q-planning_])[

  #align(center)[#image("images/q-plan.png", width:100%)]

  La diferencia entre #alert[_Q-learning_] y #alert[_Q-planning_] es de dónde proviene la información empleada para mejorar la política (entorno real _vs._ modelo del entorno).
  
]

// *****************************************************************************

#new-section-slide("Dyna")

// *****************************************************************************

#slide(title: [Planificación _online_])[

  La *experiencia* de un agente puede emplearse para:

  #shadow[1. *Mejorar su modelo del entorno* (hacerlo más preciso).]
    #h(1cm) #emoji.circle.blue Aprendizaje del modelo (#alert[*_Model learning_*])
    
  #shadow[2. *Mejorar la estimación de la función de valor y la política*]
    #h(1cm) #emoji.circle.yellow RL directo (#alert[*_DIRECT reinforcement learning_*])
    
    #h(1cm) #emoji.circle.green RL indirecto (#alert[*_INDIRECT *reinforcement learning*_*])
]

// *****************************************************************************

#slide(title: [Planificación _online_])[
  #box(height:450pt)[
    La relación entre *experiencia*, *modelo*, *función de valor* y *política* es la siguiente: 
    #align(center)[#image("images/dynaq-diagram.png", width:50%)]
  ]
]

// *****************************************************************************

#slide(title: [RL directo _vs._ indirecto])[
  #box(height:450pt)[

    #text(size:17pt)[
      La #alert[experiencia] sirve para mejorar las funciones de valor y las políticas, ya sea *directa* o *indirectamente* a partir del modelo.
      
      #columns(2)[
        
      #shadow[#emoji.circle.green *RL indirecto* (#alert[*_INDIRECT RL_*]): permite obtener una buena política con pocas interacciones con el entorno real.]
      
        - Se basa en la *planificación* a partir del modelo.
  
      #shadow[#emoji.circle.yellow *RL directo* (#alert[*_DIRECT RL_*]): es una solución más simple que no se ve afectada por sesgos en el diseño del modelo.]
      
        - *Aprendizaje* basado en la interacción directa con el entorno real.
  
      #colbreak()
      
      #align(center)[#image("images/dynaq-diagram.png")]
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: [Pregunta...])[

  #align(center)[#shadow[¿En qué se diferencia *planificación* de *aprendizaje*?]]

]

// *****************************************************************************

#slide(title: [Pregunta...])[

  #align(center)[#shadow[¿En qué se diferencia *planificación* de *aprendizaje*?]]

  #text(size:18pt)[
  - La #text(fill:blue)[*planificación*] *decide una secuencia de acciones antes de que se tomen*, basándose en un modelo del entorno predefinido.
      - Se emplea cuando contamos con un modelo fiable, o cuando la interacción con el entorno es costosa/arriesgada.
      - Ej. programación dinámica.

  - El #text(fill:olive)[*aprendizaje*] sí *requiere de la experiencia con el entorno*, ya sea para aprender las funciones de valor/política directamente (_direct RL_), o indirectamente (_indirect RL_) a través de un modelo ajustado con la experiencia obtenida.
      - Se emplea cuando no hay un modelo del entorno, o es incompleto.
      - Ej. métodos basados en TD.
  ]
]

// *****************************************************************************

#focus-slide[*Dyna-Q*]

// *****************************************************************************

#slide(title: [Dyna-Q])[

  #definition(title:[*Dyna-Q*])[Arquitectura de agente que integra #alert[*planificación*], #alert[*actuación*] y #alert[*aprendizaje*] de forma *_online_*.]

]

// *****************************************************************************

#slide(title: [Arquitectura de Dyna-Q])[
  #align(center)[
    #box(height:450pt)[
      
      #image("images/dynaq.png")
    ]
  ]

]

// *****************************************************************************

#slide(title: [Arquitectura de Dyna-Q])[
  #align(center)[
    #box(height:450pt)[
      
      #image("images/dynaq-2.png")

    ]
  ]

]

// *****************************************************************************

#slide(title: [Modelo en Dyna-Q])[

  #box(height:450pt)[

      #shadow[
        Al *modelo* se le consulta un par #alert[estado--acción] previamente experimentado, y devuelve los siguientes #alert[estado--recompensa] como predicción.
      ]

      #v(1cm)

      #text(size:24pt)[
        $ m(S_t, A_t) --> S_(t+1), R_(t+1) $
      ]

      #v(1cm)

      Contar con un buen modelo suponer necesitar de menos experiencia *real* para alcanzar una misma política $arrow$ se reducen las interacciones con el entorno.
      
  ]

]

// *****************************************************************************

#slide(title: [Control de búsqueda])[
    #box(height:450pt)[
      #columns(2)[

        #v(2cm)
        Se denomina #alert[*control de búsqueda*] (_search control_) al proceso de selección del estado--acción inicial en la *experiencia simulada* obtenida del *modelo* y empleada para aprender mediante *planificación*.
      
        #colbreak()

        #align(center)[#image("images/search-control.png")]
      ]
  ]
]

// *****************************************************************************

#slide(title: [Método de aprendizaje])[
    #box(height:450pt)[

      Generalmente, Dyna-Q emplea el #alert[*mismo método*] para el *aprendizaje* a partir de experiencia *real* y *simulada* (ej. _1-step Q-learning_).
  
      #shadow[#alert[*Aprendizaje*] y #alert[*planificación*] solamente varían en la *procedencia* de la *experiencia* empleada (entorno real o modelo del entorno).]
    ]
]

// *****************************************************************************

#slide(title: [Procesos en Dyna-Q])[
    #box(height:450pt)[

      Conceptualmente, la *planificación*, *actuación*, *aprendizaje del modelo* y *aprendizaje directo mediante RL* ocurren #alert[simultáneamente].

      No obstante, la implementación de Dyna-Q de forma secuencial requiere dividir estos procesos dependiendo de sus #alert[requisitos computacionales]:

      #columns(2)[

        #shadow[
          - *Actuación*
          - *Aprendizaje del modelo*
          - *RL directo*

          Ocurren rápidamente y prácticamente en paralelo.
        ]
        
        #colbreak()

        #shadow[
          - *Planificación*

          Implica operaciones más costosas que requieren un mayor tiempo de ejecución.
        ]
        
      ]      
    ]
]

// *****************************************************************************

#slide(title: [Dyna-Q])[
    #box(height:450pt)[
      #align(center)[#image("images/tabular-dynaq.png")]      
    ]
]

// *****************************************************************************

#slide(title: [Dyna-Q])[
    #box(height:450pt)[

        #align(center)[#image("images/tabular-dynaq.png", width:75%)]

        #v(0.5cm)

        #columns(3, gutter:0pt)[
        
          #text(size:14pt)[
            *(a)* Percibir estado
            
            *(b)* Seleccionar acción
            
            *(c)* #alert[Actuar] y observar transición

            #colbreak()
            
            #h(20pt) *(d)* #alert[RL directo]
            
            #h(20pt) *(e)* #alert[Aprendizaje del modelo]

            #h(20pt) *(f)* #alert[Planificación]

            #colbreak()
  
            Si eliminamos *(e)* y *(f)*, tenemos el _1-step tabular Q-learning_ convencional.
  
            Los dos primeros pasos en *(f)* se corresponden con _search control_.

           ]  
        ]

  ]
]

// *****************************************************************************

#slide(title: [Dyna-Q])[
    #box(height:450pt)[

        #align(center)[#image("images/tabular-dynaq.png", width:75%)]

        #columns(2)[
        
         #text(size:14pt)[

           #shadow[Se realizan tantas #alert[*iteraciones de planificación*] ($n$) como se especifiquen en *(f)*.
         ]

           #colbreak()

           #shadow[Si $n = 0$, tenemos un agente de RL convencional (_direct RL_) que no planifica.]

           #colbreak()

         ]  
      ]

  ]
]

// *****************************************************************************

#slide(title: [Planificación])[
  #box(height:450pt)[
 
    En la práctica, invertir en planificación puede suponer un #alert[aprendizaje más rápido]...

    #align(center)[#image("images/example-dynaq.png", width:60%)]

  ]
]

// *****************************************************************************

#slide(title: [Planificación])[
  #box(height:450pt)[
 
    En la práctica, invertir en planificación puede suponer un #alert[aprendizaje más rápido]...

    #v(1cm)

    #align(center)[#image("images/example-dynaq-2.png")]

  ]
]

// *****************************************************************************

#slide(title: [Dyna-Q])[
  #box(height:450pt)[
    
     #definition(title: text(size:19pt)[#emoji.books Sutton, R. S., & Barto, A. G. (2018). *_Reinforcement learning: An introduction_*. MIT press.])[

        #v(0.5cm)
       
        _In #alert[*Dyna-Q*], *learning* and *planning* are accomplished by exactly the same algorithm, operating on *real experience* for *learning* and on *simulated experience* for *planning*. Because planning proceeds incrementally, it is trivial to *intermix* planning and acting. Both proceed as fast as they can._
        
        #v(1cm)
        
        _The agent is always reactive and always deliberative, responding instantly to the latest sensory information and yet always planning in the background. Also ongoing in the background is the *model-learning process*. As new information is gained, the model is *updated* to better *match reality*. As the model changes, the ongoing *planning* process will gradually compute a different way of behaving to *match* the new model._

        #v(0.5cm)
        
      ]

  ]
]

// *****************************************************************************

#focus-slide([*Hablando en Python...*])

// *****************************************************************************

#slide(title: [Dyna-Q])[
  #align(center)[
    #box(height:500pt)[
      #text(size:19pt)[
        ```python
        def dynaq(self, env, n_episodes, plan_steps, alpha, gamma, epsilon):

          q_table, model = {}, {}

          for _ in range(n_episodes):
            s = env.start_pos
            while True: 

                if s not in self.q_table:
                    q_table[s] = {action: 0 for action in env.actions}

                a = e_greedy(s, actions, epsilon)
                
                s_next, r, end = env.step(s, a)

                if s_next not in self.q_table:
                    self.q_table[s_next] = {
                        action: 0 for action in env.actions}
               ...
        ```
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: [Dyna-Q])[
  #align(center)[
    #box(height:500pt)[
      #text(size:22pt)[
        ```python
                ...

                # Q-learning update
                td_target = r + gamma * max(q_table[s_next].values())
                td_error = td_target - q_table[s][a]
                q_table[s][a] += alpha * td_error
                
                # Update Model
                if s not in model:
                    model[s] = {}
                model[s][a] = (s_next, r)

                ...
        ```
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: [Dyna-Q])[
  #align(center)[
    #box(height:500pt)[
      #text(size:20pt)[
        ```python
                ...

                # Planning
                for _ in range(plan_steps):
                    sim_s = random.choice(list(self.model.keys()))
                    sim_a = random.choice(list(self.model[sim_s].keys()))

                    sim_s_next, sim_r = self.model[sim_s][sim_a]

                    sim_td_target = sim_r + self.gamma * \
                        max(self.q_table[sim_s_next].values())
                    sim_td_error = sim_td_target - self.q_table[sim_s][sim_a]
                    self.q_table[sim_s][sim_a] += self.alpha * sim_td_error

                s = s_next

                if end:
                    break          

        ```
      ]
    ]
  ]
]

// *****************************************************************************

#focus-slide([*¿Qué ocurre si el modelo NO es preciso?*])

// *****************************************************************************

#slide(title: [Modelos imprecisos])[
  #box(height:450pt)[
  
    Si un *modelo* del entorno *no es preciso*, las transiciones predichas no son correctas.

    - Es decir, la función de transición $p(s,a|s',r)$ modelada *no se ajusta a la realidad*.

    #shadow[Los errores en los modelos se deben a la #alert[*estocasticidad*] de los entornos en combinación con la #alert[*falta de experiencia*].]

    Si el entorno cambia con el tiempo, un modelo aprendido puede dejar de ser útil.

   
    #text(size:9pt)[\* Otra posibilidad es que el modelo empleado generalice de forma imperfecta, en caso de que sea un modelo obtenido mediante aproximación de funciones.]
  
  ]
]

// *****************************************************************************

#slide(title: [Errores en los modelos])[
  #box(height:450pt)[
  
    Por tanto:

    + Modelos que no contienen todas las *transiciones* #emoji.arrow.r #text(fill:red)[*MODELOS INCOMPLETOS*]

    + Modelos imprecisos porque el *entorno* ha variado #emoji.arrow.r #text(fill:blue)[*MODELOS DESACTUALIZADOS*]
  
  ]
]

// *****************************************************************************

#slide(title: [Ejemplo])[
  #align(center)[#box(height:450pt)[ 
    #image("images/env-change.png")
  ]]
]

// *****************************************************************************

#slide(title: [Modelos imprecisos])[
  #box(height:450pt)[

    #shadow[¿Qué ocurre si *planificamos* con modelos imprecisos?]

    - Si el modelo es *incompleto*, necesitamos tiempo para #alert[almacenar transiciones y obtener experiencia].

    - Si el modelo *difiere de la realidad* porque el *entorno* real ha cambiado, la política/función de valor puede actualizarse en una #alert[dirección errónea].
  
  ]
]

// *****************************************************************************

#slide(title: [Políticas subóptimas])[
  #box(height:450pt)[

    #shadow[Cuando el modelo es incorrecto, la planificación da lugar a #alert[*políticas subóptimas*].]
  
    En algnos casos, la política subóptima obtenida mediante planificación puede llevar al #alert[*descubrimiento*] y #alert[*corrección*] de los *errores* del modelo.

    - Esto ocurre principalmente cuando el modelo es *optimista* y se predicen mejores recompensas o transiciones de las que son realmente posibles.

    - La política subóptima trata de explotar estas oportunidades y de esta forma descubre que *sus expectativas son falsas*.
  
  ]
]

// *****************************************************************************

#slide(title: [Modelos en entornos estocásticos])[
  #box(height:450pt)[

    Para el agente, es necesario mantener la certeza de que su modelo se encuentra correctamente actualizado.

    La *exploración* le permite asegurar la precisión del modelo, al mismo tiempo que se dedica a la *explotación* de la política óptima (asumiendo que es correcta).
  
  ]
]

// *****************************************************************************

#slide(title: [Modelos imprecisos con Dyna-Q])[
  #box(height:450pt)[

    Una ventaja de #alert[*Dyna-Q*] es que permite planificar aun contando con un modelo incompleto, ya que sólo muestrea estados y acciones que hayan sido *previamente* *visitados*. Véanse los primeros dos pasos de *(f)*:

    #align(center)[#image("images/tabular-dynaq.png", width:80%)]
  
  ]
]

// *****************************************************************************

#new-section-slide([Dyna-Q+])

// *****************************************************************************

#slide(title: [Dyna-Q+])[
  #box(height:450pt)[

    #shadow[Es más probable que un #alert[*modelo*] esté *desactualizado* en #alert[*estados/acciones*] que lleven más *tiempo sin visitarse*.]

    Para asegurar que el agente revisita estados periódicamente, podemos añadir un "*bonus*" a la recompensa empleada en la planificación.

    Esta es la propuesta del algoritmo #alert[*Dyna-Q+*].
  
  ]
]

// *****************************************************************************

#slide(title: [Dyna-Q+])[

    #align(center)[#image("images/dynaq+.png")]

]

// *****************************************************************************

#slide(title: [Dyna-Q+])[
  #box(height:400pt)[
    #columns(2)[

    #v(0.25cm)
    
    #align(center)[#image("images/dynaq+.png")]

    #shadow[#alert[*Dyna-Q+*] mantiene un registro de los *_time steps_ transcurridos desde la última ocurrencia* de cada par acción--estado en el entorno real.]

    #colbreak()

    #v(1.5cm)

    Cuanto más tiempo haya transcurrido, se asume una mayor probabilidad de que las dinámicas asociadas a un par acción--estado hayan cambiado y que, por tanto, el modelo sea *incorrecto*.

    - Para favorecer que "se vuelva intentar", se añade un #alert[_bonus_] a la recompensa de las experiencias simuladas que impliquen al par poco visitado.

    ]
  ]
]

// *****************************************************************************

#slide(title: [Dyna-Q+])[
  #box(height:400pt)[
    #columns(2)[

    #v(1cm)
    
    #align(center)[#image("images/dynaq+.png")]

    
    Si la recompensa de una transición es $r$ y la transición no se ha probado desde hace $tau$ _time steps_, la recompensa de esa transición pasa a ser #alert[$r + kappa sqrt(tau)$], siendo $kappa$ un valor pequeño.

    #colbreak()

    #v(1.5cm)

    #align(center)[#shadow[$ r' = r + kappa sqrt(tau) $]]

    Se promueve que el agente revisite estados cada _X_ tiempo para confirmar que el modelo esté actualizado.

    Se actualiza la *política* para dirigir al agente a *estados/acciones no visitados* desde hace tiempo.

    De esta forma, mantenemos el #alert[modelo actualizado].
    
    ]
  ]
]

// *****************************************************************************

#slide(title: [Ejemplo])[
  #align(center)[
    #box(height:400pt)[
      #columns(2)[
        #image("images/dyna-q-comparison.png")
        #colbreak()
        #image("images/dyna-q-comparison-2.png")
      ]
    ]
  ]
]

// *****************************************************************************

#slide(title: "Trabajo propuesto")[

  #box(height:500pt)[
    #text(size:18pt)[
  
      - Prueba esta *implementación de DynaQ* y trata de hacer la tuya:
      
        #text(size:16pt)[#shadow[#alert[https://github.com/manjavacas/rl-temario/tree/main/codigo/dynaq]]]
        
        #emoji.circle.blue Pruébala en un entorno de *Gymnasium* (ej. _Frozen Lake_).

      - Leer capítulos _*8.6. Trajectory Sampling*_ y _*8.11. Monte Carlo Tree Search*_ de Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.

        - _¿Conoces alguna aplicación conocida donde se haya utilizado #alert[Monte Carlo Tree Search]?_
      
      === Bibliografía y webs recomendadas:
      
        #text(size:14pt)[
          - *Capítulo 8* de Sutton, R. S., & Barto, A. G. (2018). Reinforcement learning: An introduction.
          - https://youtu.be/ItMutbeOHtc?si=XFPMlOxD6MZNQgUy
          - https://youtu.be/jlC0TFTUefs?si=O_L4fL6ddW8X1N_U
          - https://youtu.be/aUjuBvqJ8UM?si=lU11f24dn27LnISD
          - https://www.davidsilver.uk/wp-content/uploads/2020/03/dyna.pdf
          
        ]
    ]
  ]
]

// *****************************************************************************

#title-slide(
  author: [Antonio Manjavacas Lucas],
  title: "Aprendizaje por refuerzo",
  subtitle: "Planificación",
  extra: "manjavacas@ugr.es"
)