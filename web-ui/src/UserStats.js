import { Row, Col, Card, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import React, { PureComponent } from 'react';
import { PieChart, Pie, Sector, Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Treemap, ResponsiveContainer } from 'recharts';
import { connect } from 'react-redux';

const renderActiveShape = (props) => {
  const RADIAN = Math.PI / 180;
  const { cx, cy, midAngle, innerRadius, outerRadius, startAngle, endAngle, fill, payload, percent, value } = props;
  const sin = Math.sin(-RADIAN * midAngle);
  const cos = Math.cos(-RADIAN * midAngle);
  const sx = cx + (outerRadius + 10) * cos;
  const sy = cy + (outerRadius + 10) * sin;
  const mx = cx + (outerRadius + 30) * cos;
  const my = cy + (outerRadius + 30) * sin;
  const ex = mx + (cos >= 0 ? 1 : -1) * 22;
  const ey = my;
  const textAnchor = cos >= 0 ? 'start' : 'end';

  return (
    <g>
      <text x={cx} y={cy} dy={8} textAnchor="middle" fill={fill}>
        {payload.name}
      </text>
      <Sector
        cx={cx}
        cy={cy}
        innerRadius={innerRadius}
        outerRadius={outerRadius}
        startAngle={startAngle}
        endAngle={endAngle}
        fill={fill}
      />
      <Sector
        cx={cx}
        cy={cy}
        startAngle={startAngle}
        endAngle={endAngle}
        innerRadius={outerRadius + 6}
        outerRadius={outerRadius + 10}
        fill={fill}
      />
      <path d={`M${sx},${sy}L${mx},${my}L${ex},${ey}`} stroke={fill} fill="none" />
      <circle cx={ex} cy={ey} r={2} fill={fill} stroke="none" />
      <text x={ex + (cos >= 0 ? 1 : -1) * 12} y={ey} textAnchor={textAnchor} fill="#333">{`PV ${value}`}</text>
      <text x={ex + (cos >= 0 ? 1 : -1) * 12} y={ey} dy={18} textAnchor={textAnchor} fill="#999">
        {`(Rate ${(percent * 100).toFixed(2)}%)`}
      </text>
    </g>
  );
};


export default function UserStats(user) {

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
      A: user.loudness,
      fullMark: 1,
    },
    {
      feature: "valence",
      A: user.valence,
      fullMark: 1,
    }
  ];

  const user_artists = [];

  var i;
  for (i = 0; i < user.top_artists.length; i++) { 
    var artistItem = {
      name: user.top_artists[i],
      children: [
        { name: user.top_artists[i], size: (user.top_artists.length - i) * 1000}
      ]
    };

    user_artists.push(artistItem);
  }

  const genres = [
    { name: 'Group A', value: 400 },
    { name: 'Group B', value: 300 },
    { name: 'Group C', value: 300 },
    { name: 'Group D', value: 200 },
  ];

  var state = {
    activeIndex: 0,
  };

  const onPieEnter = (_, index) => {
    state = {
      activeIndex: index,
    };
  };

  

  // rap
  // hip hop
  // country
  // edm
  // pop
  // dubstep
  // jaz
  // rnb
  // indie

  // 1) Classical, Ensemble & Opera includes romantic era, early modern classical, a cappella
  // 2) Ambient, Relaxation & Experimental includes compositional ambient, lo-fi beats, new age
  // 3) Hip-Hop & Rap includes trap music, gangster rap, underground rap
  // 4) Pop includes dance pop, post-teen pop, pop rap
  // 5) Country includes contemporary country, country road, nashville sound
  // 6) Dance & Electronic includes edm, tropical house, funk carioca
  // 7) Latin & Caribbean includes reggaeton, latin trap, latin pop
  // 8) Rock, Punk & Metal includes modern rock, protopunk, alternative metal

  console.log("artists in reg format: " + user.top_artists);
  console.log("artists in graph format: " + user_artists);


  // IMPACT SCORE KEY ----------------------------------------------------------
  // Starting a party = 
  // Sending a request =
  // Getting a request approved = 
  // Adding a friend = 

  return (
    <div>
      <h3>Top Artists</h3>
      <div>
        <Treemap width={400} height={200} data={user_artists} dataKey="size" ratio={4 / 3} stroke="#fff" fill="#8884d8" />
      </div>
      <h3>Top Genres</h3>
      <div>
        <PieChart width={400} height={400}>
          <Pie
            activeIndex={state.activeIndex}
            activeShape={renderActiveShape}
            data={genres}
            cx="50%"
            cy="50%"
            innerRadius={60}
            outerRadius={80}
            fill="#8884d8"
            dataKey="value"
            onMouseEnter={onPieEnter}
          />
        </PieChart>
      </div>
      <p>{user.top_genres[0]}</p>
      <h3>Top Styles</h3>
      <div style={{color: 'white'}}>
        <RadarChart
            cx={300}
            cy={250}
            outerRadius={150}
            width={500}
            height={500}
            data={user_features}
            fill="#E8E8E8"
          >
            <PolarGrid />
            <PolarAngleAxis dataKey="feature" />
            <PolarRadiusAxis />
            <Radar 
              name="Features"
              dataKey="A"
              stroke="#8884d8"
              fill="#8884d8"
              fillOpacity={0.7}
            />
          </RadarChart>
      </div>
      <p>{user.energy}</p>
      <p>{user.danceability}</p>
      <p>{user.loudness}</p>
      <p>{user.valence}</p>
      <h3>Impact Score</h3>
      <p>{user.impact_score}</p>
    </div>
  );
}