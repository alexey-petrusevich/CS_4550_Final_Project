import React, { PureComponent, Component } from 'react';
import RGL, { WidthProvider } from "react-grid-layout";
import { PieChart, Pie, Tooltip, Sector, Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Treemap, ResponsiveContainer, LabelList, Label, Legend, Cell } from 'recharts';

const ReactGridLayout = WidthProvider(RGL);

export default function UserStats(user) {

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

  var i;
  for (i = 0; i < user.top_artists.length; i++) { 
    var artistItem = {
      name: user.top_artists[i][0],
      children: [
        { name: user.top_artists[i][0], size: (user.top_artists[i][1] * 0.75) * 1000}
      ]
    };

    user_artists.push(artistItem);
  }
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

    genres.splice(genre_index, 1, {name: genres[genre_index].name, value: genres[genre_index].value + Math.round(((user.top_genres[j][1] * 0.678) * 50))});
    genres.sort(function(a, b){return a.value - b.value})
  }

  //#endregion

  return (
    <div className="user-stats-page">
      <h3>Impact Score</h3>
      <p className="impact-score">{user.impact_score}</p>
      <ReactGridLayout
            rowHeight= {300}
            className="layout"
            isDraggable={false}
            isResizeable={false}
        >
        <div key="1" data-grid={{ x: 0, y: 0, w: 3, h: 5, static: true }}>
          <h3>Top Artists</h3>
          <ResponsiveContainer width="100%" height="18%">
            <Treemap width={1000} height={200} data={user_artists} dataKey="size" ratio={4 / 3} stroke="#fff" fill="#8884d8" />
          </ResponsiveContainer>
        </div>
        <div key="2" data-grid={{ x: 4, y: 0, w: 4, h: 5, static: true }}>
          <h3>Top Genres</h3>
          <ResponsiveContainer width="100%" height="20%">
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
                outerRadius="70%"
                fill="#8884d8"
                label
                >
                {
                  genres.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={genre_colors[index]}/>
                  ))
                }
                {/* <LabelList dataKey="name" position="outside" /> */}
              </Pie>
              <Tooltip />
            </PieChart>
          </ResponsiveContainer>
        </div>
        <div key="3" data-grid={{ x: 9, y: 0, w: 4, h: 5, static: true }}>
          <h3>Top Styles</h3>
          <ResponsiveContainer width="100%" height="20%">
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
                  <LabelList dataKey="A" position="end" />
                </Radar>
              </RadarChart>
          </ResponsiveContainer>
        </div>
      </ReactGridLayout>
    </div>
  );
}