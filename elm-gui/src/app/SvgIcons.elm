module SvgIcons exposing (..)

import Svg exposing (Svg, circle, g, path, polyline, svg)
import Svg.Attributes exposing (class, cx, cy, d, fill, height, id, points, r, stroke, strokeWidth, transform, version, viewBox, width, x, y)
import Utils


search : Svg msg
search =
    svg [ class "search-icon", version "1.1", x "0px", y "0px", viewBox "0 0 512 512" ]
        [ path [ d "M141.367,116.518c-7.384-7.39-19.364-7.39-26.748,0c-27.416,27.416-40.891,65.608-36.975,104.79 c0.977,9.761,9.2,17.037,18.803,17.037c0.631,0,1.267-0.032,1.898-0.095c10.398-1.04,17.983-10.316,16.943-20.707 c-2.787-27.845,6.722-54.92,26.079-74.278C148.757,135.882,148.757,123.901,141.367,116.518z" ]
            []
        , path [ d "M216.276,0C97.021,0,0,97.021,0,216.276s97.021,216.276,216.276,216.276s216.276-97.021,216.276-216.276 S335.53,0,216.276,0z M216.276,394.719c-98.396,0-178.443-80.047-178.443-178.443S117.88,37.833,216.276,37.833 c98.39,0,178.443,80.047,178.443,178.443S314.672,394.719,216.276,394.719z" ]
            []
        , path [ d "M506.458,479.71L368.999,342.252c-7.39-7.39-19.358-7.39-26.748,0c-7.39,7.384-7.39,19.364,0,26.748L479.71,506.458 c3.695,3.695,8.531,5.542,13.374,5.542c4.843,0,9.679-1.847,13.374-5.542C513.847,499.074,513.847,487.094,506.458,479.71z" ]
            []
        ]


rightArrow : Svg msg
rightArrow =
    svg [ class "arrow", viewBox "0 0 268.832 268.832" ]
        [ g []
            [ path [ d "M265.171,125.577l-80-80c-4.881-4.881-12.797-4.881-17.678,0c-4.882,4.882-4.882,12.796,0,17.678l58.661,58.661H12.5 c-6.903,0-12.5,5.597-12.5,12.5c0,6.902,5.597,12.5,12.5,12.5h213.654l-58.659,58.661c-4.882,4.882-4.882,12.796,0,17.678 c2.44,2.439,5.64,3.661,8.839,3.661s6.398-1.222,8.839-3.661l79.998-80C270.053,138.373,270.053,130.459,265.171,125.577z" ]
                []
            ]
        ]


notice : Svg msg
notice =
    svg [ viewBox "0 0 24 24", class "kirk-icon sc-3dofso-0 fsiSTb", width "24", height "24" ]
        [ g [ transform "translate(-1 -1)", fill "none" ]
            [ path [ d "M12 22.065C6.441 22.065 1.935 17.56 1.935 12 1.935 6.441 6.44 1.935 12 1.935c5.559 0 10.065 4.506 10.065 10.065 0 5.559-4.506 10.065-10.065 10.065zm0-1a9.065 9.065 0 1 0 0-18.13 9.065 9.065 0 0 0 0 18.13z", fill "#708C91" ]
                []
            , path [ d "M10.26 11.63a.5.5 0 1 1 0-1H12a.5.5 0 0 1 .5.5v5.218a.5.5 0 1 1-1 0V11.63h-1.24zm0 5.218a.5.5 0 1 1 0-1h3.48a.5.5 0 1 1 0 1h-3.48z", fill "#708C91" ]
                []
            , circle [ fill "#708C91", cx "12", cy "7.652", r "1" ]
                []
            ]
        ]


rightArrowTip : Svg msg
rightArrowTip =
    svg [ viewBox "0 0 24 24" ]
        [ polyline [ fill "none", stroke "#708C91", points "9 18 15 12 9 6" ]
            []
        ]


speechBubble : Svg msg
speechBubble =
    svg [ viewBox "0 0 24 24" ]
        [ path [ d "M21.951,10.281C21.98,10.023,22,9.764,22,9.5C22,4.813,17.29,1,11.5,1C5.71,1,1,4.813,1,9.5c0,1.801,0.691,3.52,2,4.979 V19.5c0,0.173,0.09,0.334,0.237,0.426C3.317,19.975,3.409,20,3.5,20c0.077,0,0.153-0.018,0.224-0.053l4.431-2.215 C9.667,19.752,12.424,21,15.5,21c0.547,0,1.097-0.042,1.636-0.123l4.141,2.07C21.347,22.982,21.424,23,21.5,23 c0.092,0,0.183-0.025,0.263-0.074C21.91,22.834,22,22.673,22,22.5v-3.814c1.292-1.173,2-2.651,2-4.186 C24,12.946,23.27,11.461,21.951,10.281z M3.865,13.943C2.645,12.641,2,11.104,2,9.5C2,5.364,6.262,2,11.5,2S21,5.364,21,9.5 S16.738,17,11.5,17c-1.023,0-2.045-0.135-3.038-0.399c-0.118-0.029-0.244-0.019-0.353,0.036L4,18.691v-4.406 C4,14.158,3.952,14.036,3.865,13.943z M21.176,18.079C21.064,18.175,21,18.313,21,18.46v3.23l-3.561-1.78 c-0.094-0.048-0.203-0.064-0.307-0.046C16.597,19.954,16.047,20,15.5,20c-2.334,0-4.511-0.826-5.917-2.162 C10.219,17.935,10.858,18,11.5,18c4.962,0,9.12-2.804,10.212-6.554C22.543,12.351,23,13.411,23,14.5 C23,15.805,22.353,17.076,21.176,18.079z" ]
            []
        ]


smoking : Bool -> Svg msg
smoking isAllowed =
    svg [ viewBox "0 0 24 24", class "kirk-icon sc-3dofso-0 fsiSTb", width "24", height "24" ]
        [ g []
            [ path [ d "M22.558,17.817L8.371,9.626C7.908,9.359,7.27,9.532,7.004,9.992l-1.518,2.629c-0.275,0.477-0.111,1.09,0.366,1.366l14.188,8.191c0.151,0.087,0.324,0.133,0.498,0.133c0.356,0,0.688-0.19,0.867-0.499l1.518-2.629C23.198,18.706,23.035,18.094,22.558,17.817z M20.54,21.312C20.54,21.312,20.539,21.312,20.54,21.312l-14.188-8.19l1.518-2.629l14.187,8.191L20.54,21.312z" ]
                []
            , path [ d "M4.237,5.03C4.471,5.175,4.78,5.103,4.925,4.868l1.14-1.843c1.002-1.619,3.079-2.142,4.727-1.19l5.47,3.158c0.693,0.4,1.463,0.605,2.242,0.605c0.391,0,0.784-0.052,1.172-0.155c1.161-0.312,2.132-1.056,2.731-2.097l0.234-0.406c0.139-0.239,0.057-0.545-0.183-0.683c-0.238-0.136-0.545-0.057-0.683,0.183l-0.235,0.406c-0.467,0.81-1.221,1.389-2.124,1.63c-0.904,0.243-1.846,0.118-2.655-0.35l-5.47-3.158c-2.121-1.225-4.79-0.552-6.078,1.53l-1.14,1.843C3.93,4.576,4.002,4.884,4.237,5.03z" ]
                []
            , path [ d "M10.52,3.568C9.325,2.878,7.794,3.289,7.105,4.483L6.611,5.338C6.473,5.577,6.555,5.883,6.794,6.021c0.237,0.138,0.544,0.056,0.683-0.183l0.494-0.854c0.2-0.347,0.524-0.595,0.911-0.699c0.388-0.104,0.791-0.05,1.138,0.15l5.152,2.975c0.079,0.045,0.165,0.067,0.25,0.067c0.172,0,0.341-0.089,0.433-0.25c0.139-0.239,0.057-0.545-0.183-0.683L10.52,3.568z" ]
                []
            , path [ d "M3.183,6.727C2.944,6.588,2.638,6.67,2.5,6.91l-2,3.464c-0.138,0.239-0.056,0.545,0.183,0.683c0.079,0.045,0.165,0.067,0.25,0.067c0.173,0,0.341-0.089,0.434-0.25l2-3.464C3.504,7.171,3.422,6.865,3.183,6.727z" ]
                []
            , path [ d "M5.183,8.067C4.944,7.929,4.638,8.01,4.5,8.25l-2,3.464c-0.138,0.239-0.056,0.545,0.183,0.683c0.079,0.046,0.165,0.067,0.25,0.067c0.173,0,0.341-0.09,0.434-0.25l2-3.464C5.504,8.511,5.422,8.205,5.183,8.067z" ]
                []
            ]
        , Utils.viewIf (not isAllowed) cross
        ]


pets : Bool -> Svg msg
pets isAllowed =
    svg [ viewBox "0 0 24 24", class "kirk-icon sc-3dofso-0 fsiSTb", width "24", height "24" ]
        [ path [ d "M7.036 7.486L6.541 5.82a2.24 2.24 0 114.292-1.276l.496 1.667a2.24 2.24 0 01-4.293 1.276zm3.334-.991l-.495-1.667a1.24 1.24 0 10-2.376.706l.496 1.667a1.24 1.24 0 002.375-.706zm5.635.706l.496-1.667a1.24 1.24 0 10-2.376-.706l-.495 1.667a1.24 1.24 0 002.375.706zm-3.334-.991l.496-1.667a2.24 2.24 0 114.292 1.276l-.495 1.667A2.24 2.24 0 0112.67 6.21zm-9.833 6.26l-.366-.428a2.24 2.24 0 013.404-2.91l.366.43a2.24 2.24 0 01-3.404 2.909zm2.644-2.259l-.366-.428a1.24 1.24 0 00-1.884 1.61l.366.428a1.24 1.24 0 101.884-1.61zm14.92 1.61l.366-.429a1.24 1.24 0 00-1.884-1.61l-.366.43a1.24 1.24 0 001.884 1.609zm-2.644-2.26l.366-.428a2.24 2.24 0 013.404 2.909l-.366.429a2.24 2.24 0 01-3.404-2.91zm-9.915 3.992l.02-.03c1.993-2.813 6.28-2.813 8.294.03l1.725 2.846c1.689 2.787-1.191 6.058-4.284 4.91l-.15-.056a4.172 4.172 0 00-2.896 0l-.15.056c-3.093 1.148-5.973-2.123-4.284-4.91l1.725-2.846zm-.87 3.364c-1.186 1.959.857 4.28 3.081 3.454l.15-.055a5.172 5.172 0 013.592 0l.15.055c2.224.826 4.267-1.495 3.08-3.454L15.323 14.1c-1.592-2.246-5.034-2.25-6.634-.014l-1.715 2.83z" ]
            []
        , Utils.viewIf (not isAllowed) cross
        ]


seat : Bool -> Svg msg
seat isFree =
    let
        fillColor =
            if isFree then
                "#000000"

            else
                "#F53F5B"
    in
    svg [ viewBox "0 0 512 512" ]
        [ g []
            [ path [ fill fillColor, d "m487.607 354.752c-28.968-11.945-59.352-21.66-90.465-29.092-4.578-56.696-27.984-107.728-64.206-138.444l72.574-72.574c1.766-1.766 2.648-3.531 2.648-6.179s-.883-4.414-2.648-6.179l-24.717-24.717c-3.531-3.531-8.828-3.531-12.359 0l-76.77 77.048c-.623-2.362-.913-4.835-.913-7.31v-15.007c21.186-12.359 35.31-35.31 35.31-60.91 0-.296-.019-.588-.023-.883.004-.295.023-.587.023-.883.001-38.843-31.778-70.622-70.62-70.622s-70.621 31.779-70.621 70.621c0 .296.019.588.023.883-.004.295-.023.587-.023.883 0 24.717 14.124 48.552 35.31 60.91v15.007c0 9.71-6.179 19.421-15.89 23.835-49.648 24.824-84.352 84.51-89.63 153.302-32.473 7.792-63.434 18.402-92.218 31.195-2.648.883-5.297 3.531-5.297 7.062s.883 6.179 3.531 7.945l35.31 23.834c2.648 1.766 5.297 1.766 7.945.883 17.334-5.778 34.1-10.839 50.441-15.19 1.171 49.677 10.732 94.224 27.241 126.418 1.766 2.648 4.414 4.414 7.945 4.414h44.138c2.648 0 7.062-1.766 7.945-4.414s1.766-6.179 0-8.828c-10.593-20.303-15.89-49.435-16.772-85.628 45.903-8.828 96.221-8.828 141.241 0-.883 36.193-6.179 65.324-16.772 85.628-1.766 2.648-1.766 6.179 0 8.828 1.766 2.648 5.297 4.414 7.945 4.414h44.138c3.531 0 6.179-1.766 7.062-4.414 16.544-32.261 26.112-76.925 27.25-126.727 16.626 4.42 33.68 9.584 51.315 15.5.883.883 1.766.883 2.648.883 1.766 0 3.531-.883 4.414-2.648l35.31-23.834c2.648-1.766 3.531-4.414 3.531-7.945.002-2.651-2.646-6.183-5.294-7.065zm-109.462-33.545c-36.2-7.542-73.043-11.85-109.43-12.949-18.63-.653-37.192-.495-55.553.498l107.604-107.604c31.779 26.482 52.965 70.62 57.379 120.055zm-145.51-203.818c-.048-.033-.097-.068-.145-.1-.976-.465-1.928-.962-2.864-1.48-14.668-8.254-25.073-23.28-26.872-40.768-.004-.038-.006-.076-.01-.114-.076-.754-.131-1.513-.174-2.275-.011-.197-.022-.393-.031-.59-.037-.81-.062-1.623-.062-2.442 0-29.131 23.834-52.966 52.966-52.966s52.966 23.835 52.083 52.966c0 20.303-11.476 38.841-30.014 47.669-.821.411-1.537.874-2.168 1.38-6.153 2.516-12.87 3.916-19.901 3.916-8.155.001-15.892-1.868-22.808-5.196zm-20.449 67.873c15.89-7.945 25.6-22.952 25.6-39.724v-7.547c5.648 1.468 11.564 2.25 17.655 2.25 5.776 0 11.39-.718 16.772-2.042v7.339c0 7.062 2.648 15.007 6.179 21.186l-144.771 144.773c7.945-57.38 37.958-105.932 78.565-126.235zm143.89 308.083h-25.6c8.828-22.952 13.241-52.966 13.241-88.276 0-4.414-2.648-7.945-7.062-8.828-51.2-11.476-110.345-11.476-162.428 0-4.414.883-7.062 4.414-7.062 8.828 0 35.31 4.414 65.324 13.241 88.276h-25.6c-14.124-30.014-22.069-70.621-22.952-116.524 3.531-.883 6.179-1.766 9.71-2.648 76.8-16.772 145.655-16.772 221.572-.883 5.297.883 10.593 2.648 15.89 3.531-.881 45.903-8.826 86.51-22.95 116.524zm92.69-115.642c-62.583-20.467-118.146-31.8-172.949-34.016-45.599-2.074-90.511 2.129-138.665 12.83-5.297 1.766-11.476 2.648-16.772 4.414-.143.072-.282.147-.422.222-18.426 4.621-37.347 10.137-56.958 16.55l-18.538-12.359c24.733-10.718 52.545-19.124 80.561-25.221.218.124.435.287.653.504.883-.883 1.766-.883 2.648-.883.185-.185.371-.325.557-.44.697-.146 1.394-.299 2.092-.442 1.766-.883 3.531-1.766 4.414-2.648l160.662-159.779c.86-.86 1.506-1.825 1.96-2.843l76.606-76.606 12.359 12.359-204.8 204.8c-2.648 2.648-3.531 6.179-1.766 9.71 1.766 3.531 5.297 5.297 8.828 5.297.116-.012.232-.022.347-.034.179.009.357.034.536.034 38.26-3.669 77.764-3.915 116.851-.368 22.898 2.169 45.705 5.608 68.22 10.279 3.647.781 7.282 1.593 10.902 2.448h.351c27.267 6.179 54.053 14.145 79.98 23.835z" ]
                []
            ]
        ]


cross : Svg msg
cross =
    g []
        [ path [ stroke "#FFF", strokeWidth "2", d "M1,24.5 L23.5,2" ]
            []
        , path [ stroke "#F53F5B", strokeWidth "2", d "M1,23.5 L23.5,1" ]
            []
        ]
