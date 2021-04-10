import React, { Badge, PureComponent, Component } from 'react';
import RGL, { WidthProvider } from "react-grid-layout";
import { Rectangle, PieChart, Pie, Tooltip, Sector, Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Treemap, ResponsiveContainer, LabelList, Label, Legend, Cell } from 'recharts';

const ReactGridLayout = WidthProvider(RGL);

export default function UserStats(user, pageId) {

  //#region ----------------------FEATURES----------------------------
  const user_features = [
    {
      feature: "danceability",
      A: user.danceability,
      fullMark: 1,
    },
    {
      feature: "energy",
      A: user.energy,
      fullMark: 1,
    },
    {
      feature: "loudness",
      A: calcLoudness(user.loudness),
      fullMark: 1,
    },
    {
      feature: "valence",
      A: user.valence,
      fullMark: 1,
    }
  ];

  function calcLoudness(val) {
    // loudness max = -1
    // loudness min = -11
    var newVal = 1 - Math.abs(val / 10);

    if (newVal >= 1) {
      newVal = 1;
    } else if (newVal <= 0.1) {
      newVal = 0.1;
    }
    return newVal;
  }
  //#endregion

  //#region ------------------------ARTISTS--------------------------
  const user_artists = [];

  var artist1 = String(user.top_artists[0]).split(',');
  var artist2 = String(user.top_artists[1]).split(',');
  var artist3 = String(user.top_artists[2]).split(',');

  var i;
  var artist_count = user.top_artists.length;
  if (artist_count > 8) {
    artist_count = 8;
  }
  for (i = 0; i < artist_count; i++) {
    var artistItem = {
      name: user.top_artists[i][0],
      children: [
        { name: user.top_artists[i][0], size: user.top_artists[i][1] },
      ]
    };
    user_artists.push(artistItem);
  }

  const artistColors = ["#43D8FF", "#34D244", "#FF87A7", "#FFFA87", "#52F0E2", "#FFBC5F", "#C887F0", "#4FFFC5"];

  // var a;
  // for (a= 0; a < user.top_artists.length; a++) {
  //   var newColor = Math.floor(Math.random()*16777215).toString(16);
  //   artistColors.push("#" + newColor);
  // }

  // Handles when there are no artists for the user
  function ProfileArtists() {
    if (user.top_artists.length < 1) {
      console.log(user.top_artists.length);
      console.log("no artists");
      return (
        <div>
          <h3>Top Artists</h3>
          <ul class="list-group" style={{'color':'black'}}>
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <p><em>Currently no top artists.</em></p>
            </li>
          </ul>
        </div>
      );
    } else {
      console.log("yes artists");
      return (
        <div>
          <h3>Top Artists</h3>
            <ul class="list-group" style={{'color':'black'}}>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                { artist1[0] }
                <span class="badge badge-primary badge-pill">{ artist1[1] } played</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                { artist2[0] }
                <span class="badge badge-primary badge-pill">{ artist2[1] } played</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                { artist3[0] }
                <span class="badge badge-primary badge-pill">{ artist3[1] } played</span>
              </li>
            </ul>
        </div>
      );
    }
  }

  // console.log(artistColors);
  //#endregion

  //#region ------------------------GENRES--------------------------
  const genres = [
    { name: 'Classical', value: 0 },
    { name: 'Ambient', value: 0 },
    { name: 'Hip Hop', value: 0 },
    { name: 'Pop', value: 0 },
    { name: 'RnB', value: 0 },
    { name: 'Country', value: 0 },
    { name: 'Electronic', value: 0 },
    { name: 'Rock', value: 0 },
    { name: 'Foreign', value: 0 },
    { name: 'Other', value: 0 },
  ];

  const genre_colors = ["#D95E36", "#C75EE1", "#327111", "#5063EC", "#F760B9", "#72D6B6", "#8DD8FF", "#E4DF30", "#00D2D0", "#EEEEEE"];

  var j;
  for (j = 0; j < user.top_genres.length; j++) {
    var genre_name = user.top_genres[j][0];

    var genre_index = 9;

    if (genre_name.includes("classical") || genre_name.includes("opera") || genre_name.includes("early music")
                || genre_name.includes("baroque") || genre_name.includes("romantic")) {
      genre_index = 0;
    } else if (genre_name.includes("experimental") || genre_name.includes("ambient") || genre_name.includes("relaxation")
                || genre_name.includes("lo-fi")) {
      genre_index = 1;
    } else if (genre_name.includes("hip hop") || genre_name.includes("rap")) {
      genre_index = 2;
    } else if (genre_name.includes("pop") || genre_name.includes("indie")) {
      genre_index = 3;
    } else if (genre_name.includes("r&b") || genre_name.includes("soul")) {
      genre_index = 4;
    } else if (genre_name.includes("country") || genre_name.includes("nashville")) {
      genre_index = 5;
    } else if (genre_name.includes("electronic") || genre_name.includes("dubstep") || genre_name.includes("edm")
                || genre_name.includes("disco") || genre_name.includes("party") || genre_name.includes("techno")
                || genre_name.includes("house")) {
      genre_index = 6;
    } else if (genre_name.includes("rock") || genre_name.includes("punk") || genre_name.includes("metal") || genre_name.includes("funk")
                || genre_name.includes("protopunk")) {
      genre_index = 7;
    } else if (genre_name.includes("foreign") || genre_name.includes("japanese") || genre_name.includes("korean")
                || genre_name.includes("latin") || genre_name.includes("reggaeton")) {
      genre_index = 8;
    }

    genres.splice(genre_index, 1, {name: genres[genre_index].name, value: genres[genre_index].value + user.top_genres[j][1]});
    // genres.sort(function(a, b){return a.value - b.value})
  }

  genres.sort(function(a, b){return b.value - a.value})

  // Handles when there are no genres for the user
  function ProfileGenres() {
    if (user.top_genres.length < 1) {
      console.log(user.top_genres.length);
      console.log("no genres");
      return (
        <div>
          <h3>Top Genres</h3>
          <ul class="list-group" style={{'color':'black'}}>
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <p><em>Currently no top genres.</em></p>
            </li>
          </ul>
        </div>
      );
    } else {
      console.log("yes genres");
      return (
        <div>
          <h3>Top Genres</h3>
            <ul class="list-group" style={{'color':'black', 'paddingLeft':'10px'}}>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                { genres[0].name }
                <span class="badge badge-primary badge-pill">{ genres[0].value } played</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                { genres[1].name }
                <span class="badge badge-primary badge-pill">{ genres[1].value } played</span>
              </li>
              <li class="list-group-item d-flex justify-content-between align-items-center">
                { genres[2].name }
                <span class="badge badge-primary badge-pill">{ genres[2].value } played</span>
              </li>
            </ul>
        </div>
      );
    }
  }

  //#endregion

  //#region ----------------------PROGRESS----------------------------

  const badgeRanks = [
    //Beginner 0 - 49
    'badge badge-secondary',
    //Silver 50 - 99
    'badge badge-info',
    //Gold 100 - 199
    'badge badge-warning',
    //Platinum 200 - 399
    'badge badge-light',
    //Elite 400+
    'badge badge-primary',
  ]

  let progressVal = Math.round(user.impact_score * 2);
  let currBadge = badgeRanks[0];
  let badgeTitle = "Noob";
  let nextGoal = 50;

  if (user.impact_score >= 50 && user.impact_score < 100) {
    currBadge = badgeRanks[1];
    badgeTitle = "Silver";
    progressVal = Math.round((user.impact_score - 50) * 2);
    nextGoal = 100;
  } else if (user.impact_score >= 100 && user.impact_score < 200) {
    currBadge = badgeRanks[2];
    badgeTitle = "Gold";
    progressVal = user.impact_score - 100;
    nextGoal = 200;
  } else if (user.impact_score == 200) {
    progressVal = 0;
    nextGoal = 400;
  } else if (user.impact_score > 200 && user.impact_score < 400) {
    currBadge = badgeRanks[3];
    badgeTitle = "Platinum";
    progressVal = (user.impact_score - 200) / 2;
    nextGoal = 400;
  } else if (user.impact_score >= 400) {
    currBadge = badgeRanks[4];
    badgeTitle = "Elite";
    progressVal = 100;
    nextGoal = 400;
  }

  //#endregion

  var layout = [
    { x: 0, y: 0, w: 2.5, h: 4, static: true },
    { x: 2.5, y: 0, w: 3, h: 4, static: true },
    { x: 5.5, y: 0, w: 3, h: 4, static: true },
  ];

  if (pageId == 1) {
    return (
      <div className="user-stats-page">
        <ReactGridLayout
              rowHeight= {300}
              className="layout"
              isDraggable={false}
              isResizeable={false}
          >
          <div key="1" data-grid={layout[0]}>
            <h3>Impact Score</h3>
            <h3><span className={currBadge}>{badgeTitle}</span></h3>
            <h4 style={{'paddingTop':'6px'}}>{user.impact_score} / {nextGoal}</h4>
            <h4 style={{'paddingTop':'0'}}><progress style={{'width':'90%'}} value={progressVal} max='100'>{progressVal}%</progress></h4>
          </div>
          <div key="2" data-grid={layout[1]}>
            <ProfileArtists />
          </div>
          <div key="3" data-grid={layout[2]}>
            <ProfileGenres />
          </div>
        </ReactGridLayout>
      </div>
    );
  } else if (pageId == 2) {

    const newLayout = [
      { x: 0, y: 0, w: 10, h: 2, static: true },
      { x: 0, y: 2, w: 10, h: 3, static: true },
      { x: 0, y: 6, w: 4, h: 3, static: true },
      { x: 4, y: 6, w: 4, h: 3, static: true },
    ];
    layout.splice(0, layout.length, ...newLayout)

    return (
      <div className="user-stats-page">
        <ReactGridLayout
              rowHeight= {45}
              className="layout"
              isDraggable={false}
              isResizeable={false}
          >
          <div key="1" data-grid={layout[0]}>
            <h4>Impact Score</h4>
            <h3><span class={currBadge}>{badgeTitle}</span>   {user.impact_score} / {nextGoal}</h3>
            <h4 style={{'paddingTop':'0'}}><progress style={{'width':'90%'}} value={progressVal} max='100'>{progressVal}%</progress></h4>
          </div>
          <div key="2" data-grid={layout[1]}>
            <h3>Top Artists</h3>
            <ResponsiveContainer width="80%" height="100%">
              <Treemap aspectRatio={2} isAnimationActive={false} type="flat" colorPanel={artistColors} width={1000} height={200} data={user_artists} dataKey="size" ratio={4 / 3} stroke="#000000"/>
            </ResponsiveContainer>
          </div>
          <div key="3" data-grid={layout[2]}>
            <h3>Top Genres</h3>
            <ResponsiveContainer width="100%" height="100%">
              <PieChart width={150} height={150}>
                <Pie
                  dataKey="value"
                  isAnimationActive={true}
                  data={genres}
                  startAngle={360}
                  endAngle={0}
                  activeIndex={0}
                  cx="50%"
                  cy="50%"
                  innerRadius="40%"
                  outerRadius="65%"
                  fill="#8884d8"
                  label
                  >
                  {
                    genres.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={genre_colors[index]}/>
                    ))
                  }
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
          <div key="4" data-grid={layout[3]}>
            <h3>Top Styles</h3>
            <ResponsiveContainer width="100%" height="100%">
              <RadarChart
                  cx="50%"
                  cy="50%"
                  outerRadius="60%"
                  width={150}
                  height={150}
                  data={user_features}
                  fill="#E8E8E8"
                >
                  <PolarGrid />
                  <PolarAngleAxis dataKey="feature" />
                  <Radar
                    name="Features"
                    dataKey="A"
                    stroke="#8884d8"
                    fill="#8884d8"
                    dot="true"
                    fillOpacity={0.7}
                  >
                  </Radar>
                </RadarChart>
            </ResponsiveContainer>
          </div>
        </ReactGridLayout>
      </div>
    );
  }
}
