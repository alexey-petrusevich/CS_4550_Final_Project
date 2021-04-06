import { Row, Col, Card, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import { ResponsiveRadar } from '@nivo/radar'

// Handles the responsive nature of the grid
const ResponsiveGridLayout = WidthProvider(Responsive);
// Determines the screen breakpoints for the columns
const breakpoints = { lg: 1200, md: 996, sm: 768, xs: 480, xxs: 320 };
// How many columns are available at each breakpoint
const cols = { lg: 4, md: 4, sm: 1, xs: 1, xxs: 1 };

const RadarSongGenres = (user_genres) => (
  <ResponsiveRadar
      data={user_genres}
      keys={[ 'chardonay', 'carmenere', 'syrah' ]}
      indexBy="taste"
      maxValue="auto"
      margin={{ top: 70, right: 80, bottom: 40, left: 80 }}
      curve="linearClosed"
      borderWidth={2}
      borderColor={{ from: 'color' }}
      gridLevels={5}
      gridShape="circular"
      gridLabelOffset={36}
      enableDots={true}
      dotSize={10}
      dotColor={{ theme: 'background' }}
      dotBorderWidth={2}
      dotBorderColor={{ from: 'color' }}
      enableDotLabel={true}
      dotLabel="value"
      dotLabelYOffset={-12}
      colors={{ scheme: 'nivo' }}
      fillOpacity={0.25}
      blendMode="multiply"
      animate={true}
      motionConfig="wobbly"
      isInteractive={true}
      legends={[
          {
              anchor: 'top-left',
              direction: 'column',
              translateX: -50,
              translateY: -40,
              itemWidth: 80,
              itemHeight: 20,
              itemTextColor: '#999',
              symbolSize: 12,
              symbolShape: 'circle',
              effects: [
                  {
                      on: 'hover',
                      style: {
                          itemTextColor: '#000'
                      }
                  }
              ]
          }
      ]}
  />
)


function UserStats(user) {

  const user_genres = user.ge

  return (
    <div>
      <h3>Top Listens</h3>
      <h3>Top Artists</h3>
      <h3>Top Genres</h3>
      <h3>Top Styles</h3>
      <h3>Impact Score</h3>
    </div>
  );
}

export default connect(({parties, session}) => ({parties, session}))(UserStats);
